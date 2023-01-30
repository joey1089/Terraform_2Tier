# --- root / main.tf ---

# Naming conventions to be followed for easy identifications:
# outputs.tf - output "instance_type_ot" - here ot stands for output
# variables.tf - variables "instance_type_var" here var stands for variable
# This helps in reduces a lot of stress in finding which is a variable or a resource name while referencing.

# install graphviz - https://developer.hashicorp.com/terraform/cli/commands/graph

module "my_ec2" {
  source = "./ec2"
  # security_group = module.security_group_web.web_sg
}

module "security_group_all" {
  source   = "./security"
  main_vpc = module.networking.vpc_id

}

module "networking" {
  source           = "./networks"
  vpc_cidr         = "10.10.0.0/16"
  private_sn_count = 5
  public_sn_count  = 2
  private_cidrs    = [for i in range(1, 255, 2) : cidrsubnet("10.10.0.0/16", 8, i)]
  public_cidrs     = [for i in range(2, 255, 2) : cidrsubnet("10.10.0.0/16", 8, i)]
  max_subnets      = 6

}

module "autoscaling" {
  source                 = "./autoscale"
  bastion_sg             = module.security_group_all.bastion_sg
  bastion_instance_count = 1
  key_name               = "Test_KeyPair"
  alb_tg_name            = module.loadbalancing.alb_tg_name
  alb_tg                 = module.loadbalancing.alb_tg
  public_subnets         = module.networking.public_subnets
  private_subnets        = module.networking.private_subnets
  user_data              = filebase64("./user-install.sh")
  instance_type          = "t2.micro"
  web_sg                 = module.security_group_all.web_sg


}

module "loadbalancing" {
  source            = "./alb"
  tg_protocol       = "HTTP"
  tg_port           = 80
  listener_protocol = "HTTP"
  listener_port     = 80
  alb_sg            = module.security_group_all.alb_sg
  public_subnets    = module.networking.public_subnets
  vpc_id            = module.networking.vpc_id
  web_asg           = module.autoscaling.web_asg
}

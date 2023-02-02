# --- root / main.tf ---

# Naming conventions to be followed for easy identifications:
# outputs.tf - output "instance_type_ot" - here ot stands for output
# variables.tf - variables "instance_type_var" here var stands for variable
# This helps in reduces a lot of stress in finding which is a variable or a resource name while referencing.

# install graphviz - https://developer.hashicorp.com/terraform/cli/commands/graph

module "my_ec2" {
  source = "./ec2"
  # security_group = module.security_group_web.rds_sg
  # networking = module.networking.rds_subnet_grp
  # rds_subnet = module.networking.rds_subnet_grp
  # rds_sg = module.security_group_all.rds_sg
  key_name_var = local.key_name
  # public_key_path = var.public_key_path

}

module "security_group_all" {
  source   = "./security"
  main_vpc = module.networking.vpc_id

}

module "networking" {
  source               = "./networks"
  vpc_cidr             = "10.10.0.0/16"
  private_sn_count     = 2
  public_sn_count      = 2
  rds_private_sn_count = 2
  # rds_private_cidrs    = [for i in range(3, 255, 2) : cidrsubnet("10.10.0.0/16", 8, i)]
  # private_cidrs        = [for i in range(1, 255, 2) : cidrsubnet("10.10.0.0/16", 8, i)]
  # public_cidrs         = [for i in range(2, 255, 2) : cidrsubnet("10.10.0.0/16", 8, i)]
  public_cidrs      = ["10.10.1.0/24", "10.10.2.0/24"]
  private_cidrs     = ["10.10.3.0/24", "10.10.4.0/24"]
  rds_private_cidrs = ["10.10.5.0/24", "10.10.6.0/24"]
  max_subnets       = 6
  # rds_subnet_grp = 
  aws_db_subnet_group = true

}

module "autoscaling" {
  source                 = "./autoscale"
  bastion_sg             = module.security_group_all.bastion_sg
  bastion_instance_count = 1
  # key_name               = "Test_KeyPair"
  key_name         = module.my_ec2.TF_key
  alb_tg_name      = module.loadbalancing.alb_tg_name
  alb_tg           = module.loadbalancing.alb_tg
  public_subnets   = module.networking.public_subnets
  private_subnets  = module.networking.private_subnets
  user_data        = filebase64("./user-install.tpl")
  instance_type    = "t2.micro"
  web_sg           = module.security_group_all.web_sg
  rds_security     = module.security_group_all.rds_sg
  rds_subnet_group = module.networking.rds_subnet_grp
  tags_rds         = "rds_db_server_instance"
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

module "database_rds" {
  source                 = "./database"
  db_storage             = 20 # minimum required by aws, free upto 100GB
  db_engine_version      = "5.7"
  db_instance_class      = "db.t2.micro"
  db_name                =  var.db_name #"mysql_rds"
  dbuser                 =  var.dbuser #"myuser"
  dbpassword             = var.dbpassword #"nopassword"
  dbidentifier          = "myrds-db"
  skip_final_snapshot    = true
  db_subnet_group_name   = module.networking.db_subnet_group_name[0]
  vpc_security_group_ids = module.security_group_all.rds_sg
}
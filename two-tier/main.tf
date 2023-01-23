# --- root / main.tf ---

# Naming conventions to be followed for easy identifications:
# outputs.tf - output "instance_type_ot" - here ot stands for output
# variables.tf - variables "instance_type_var" here var stands for variable
# This helps in reduces a lot of stress in finding which is a variable or a resource name while referencing.

module "my_ec2" {
  source = "./ec2"
  # security_group = module.security_group_web.web_sg
}


module "security_group_all" {
  source = "./security"
}
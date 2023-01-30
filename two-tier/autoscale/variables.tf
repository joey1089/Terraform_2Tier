# --- autoscale /variables.tf ---

variable "bastion_instance_count" {}
variable "instance_type" {}
variable "bastion_sg" {}
variable "private_subnets" {}
variable "public_subnets" {}
variable "key_name" {}
variable "alb_tg_name" {}
variable "alb_tg" {}
variable "web_sg" {}
variable "user_data" {}
variable "rds_subnet_group" {}
variable "rds_security" {}
variable "tags_rds" {}

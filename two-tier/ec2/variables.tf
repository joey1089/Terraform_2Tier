# --- ec2 / variables.tf ---

variable "instance_type_var" {
  default = "t2.micro"
}

# variable "rds_subnet" {}

# variable "rds_sg" {}

# variable "TF_key" {}
variable "key_name_var" {}

# variable "public_key_path" {}

variable "algorithm_type" {
  default = "RSA"
}

variable "rsa_bits" {
  default = 4096
}

# variable "filename_localkey" {
#   default = "tfkey-${substr(uuid(), 1, 2)}"  
# }

# variable "content_localkey" {
#   default = "tls_private_key.rsa.private_key_pem"
# }
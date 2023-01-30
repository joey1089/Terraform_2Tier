# --- ec2-instance/main.tf ---

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

# # ec2 not in the 2tier
# resource "aws_instance" "web_test" {
#   ami           = data.aws_ami.ubuntu.id
#   instance_type = var.instance_type_var

#   tags = {
#     Name = "web-test-ec2"
#   }
# }

# # Relational Database Service Subnet Group
# resource "aws_db_subnet_group" "rds_subnet_grp" {
#   name = "rds_subnet_grp"
#   # subnet_ids = [aws_subnet.sub_private_1.id, aws_subnet.sub_private_2.id]
#   # subnet_ids = aws_subnet.private_subnets.*.id
#   # subnet_ids = 
# }

# # Create RDS Instance
# resource "aws_db_instance" "rds_instance" {
#   allocated_storage      = 8
#   engine                 = "mysql"
#   engine_version         = "5.7"
#   instance_class         = "db.t2.micro"
#   identifier             = "dbinstance"
#   db_name                = "db_mysql"
#   username               = "admin"
#   password               = "password"
#   # db_subnet_group_name   = aws_db_subnet_group.rds_subnet_grp.id
#   db_subnet_group_name = var.rds_subnet
#   # vpc_security_group_ids = [aws_security_group.rds_private_sg.id]
#   vpc_security_group_ids = "${var.rds_sg}"
#   skip_final_snapshot    = true
# }

# Create Key pair
resource "aws_key_pair" "TF_key" {
  key_name   = var.key_name_var
  public_key = tls_private_key.rsa.public_key_openssh
  # public_key = file(var.public_key_path)

}

resource "tls_private_key" "rsa" {
  algorithm = var.algorithm_type
  rsa_bits  = 4096
}

resource "local_file" "TF-key" {
  content = tls_private_key.rsa.private_key_pem
  # filename = "tfkey-${substr(uuid(), 1, 2)}"
  filename = var.key_name_var
}
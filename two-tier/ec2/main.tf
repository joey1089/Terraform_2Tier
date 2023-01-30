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

# ec2 not in the 2tier
resource "aws_instance" "web_test" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type_var

  tags = {
    Name = "web-test-ec2"
  }
}
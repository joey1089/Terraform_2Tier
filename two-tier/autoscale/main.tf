# --- autoscale / main.tf ---
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

# Create a bastion host instance

resource "aws_launch_template" "bastion_host" {
  name_prefix            = "bastion_host"
  instance_type          = var.instance_type
  image_id               = data.aws_ami.ubuntu.id
  vpc_security_group_ids = [var.bastion_sg]
  key_name               = var.key_name

  tags = {
    Name = "bastion-host"
  }
}

resource "aws_autoscaling_group" "bastion_host_asg" {
  name                = "bastion-asg"
  vpc_zone_identifier = var.public_subnets
  min_size            = 1
  max_size            = 1
  desired_capacity    = 1

  launch_template {
    id      = aws_launch_template.bastion_host.id
    version = "$Latest"
  }
}

# Web server
resource "aws_launch_template" "web_server" {
  name_prefix            = "web-server"
  instance_type          = var.instance_type
  image_id               = data.aws_ami.ubuntu.id
  vpc_security_group_ids = [var.web_sg]
  key_name               = var.key_name
  user_data              = var.user_data

  tags = {
    Name = "web-server-${substr(uuid(), 1, 2)}"
  }
}

data "aws_alb_target_group" "web_alb_tg" {
  name = var.alb_tg_name
}

resource "aws_autoscaling_group" "web_server_asg" {
  name                      = "web-server-asg"
  vpc_zone_identifier       = var.private_subnets
  min_size                  = 2
  max_size                  = 2
  desired_capacity          = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  force_delete              = true

  target_group_arns = [data.aws_alb_target_group.web_alb_tg.arn]
  lifecycle {
    ignore_changes = [load_balancers, target_group_arns]
  }

  launch_template {
    id      = aws_launch_template.web_server.id
    version = "$Latest"
  }

}

resource "aws_autoscaling_attachment" "asg_attach" {
  autoscaling_group_name = aws_autoscaling_group.web_server_asg.id
  # alb_target_group_arn   = aws_alb_target_group.web_alb_tg.arn
  alb_target_group_arn = var.alb_tg
  # alb_targett_group_arn = aws_alb_target_group.web_alb_tg.arn
  #   aws_alb_target_group.web_alb_tg.arn
}


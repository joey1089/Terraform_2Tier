# --- alb / main.tf ----

resource "aws_alb" "web_alb" {
  name            = "web-alb"
  subnets         = var.public_subnets
  security_groups = [var.alb_sg]
  idle_timeout    = 300

  depends_on = [
    var.web_asg
  ]
}

resource "aws_alb_target_group" "web_alb_tg" {
  name     = "web-alb-tg-${substr(uuid(), 1, 4)}" # not essential
  port     = var.tg_port
  protocol = var.tg_protocol
  vpc_id   = var.vpc_id
  lifecycle {
    create_before_destroy = true
    ignore_changes        = [name]
  }
}

resource "aws_alb_listener" "web_alb_listener" {
  load_balancer_arn = aws_alb.web_alb.arn
  port              = var.listener_port
  protocol          = var.listener_protocol
  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.web_alb_tg.arn
  }
}
# --- alb/outputs.tf ---

output "alb_tg_name" {
  value = aws_alb_target_group.web_alb_tg.name
}

output "alb_tg" {
  value = aws_alb_target_group.web_alb_tg.arn
}

output "alb_dns" {
  value = aws_alb.web_alb.dns_name
}


# --- security / outputs.tf ---

output "web_sg" {
  value = aws_security_group.web_sg.id
}

output "bastion_sg" {
  value = aws_security_group.bastion_sg.id
}

output "alb_sg" {
  value = aws_security_group.alb_sg.id
}
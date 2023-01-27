# --- networks / outputs.tf ---

output "vpc_id" {
  value = aws_vpc.main_vpc.id
}


output "public_subnets" {
  value = aws_subnet.public_subnets.*.id
}


output "private_subnets" {
  value = aws_subnet.private_subnets.*.id
}

output "rds_subnet_grp" {
  value = aws_db_subnet_group.rds_subnet_grp
}
# --- networks / outputs.tf ---

output "vpc_id" {
  value = aws_vpc.main_vpc.id
}

output "db_subnet_group_name" {
  value = aws_db_subnet_group.rds_subnet_grp.*.name
}

# output "db_security_group" {
#   value = aws_security_group.
# } A managed resource "aws_security_group" "rds_sg" has not been declared in module.networking.

output "public_subnets" {
  value = aws_subnet.public_subnets.*.id
}


output "private_subnets" {
  value = aws_subnet.private_subnets.*.id
}

output "rds_subnet_grp" {
  value = aws_db_subnet_group.rds_subnet_grp
}
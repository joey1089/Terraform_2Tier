# --- database / main.tf ---


# Create RDS Instance
resource "aws_db_instance" "rds_instance" {
  allocated_storage = var.db_storage
  engine            = "mysql"
  engine_version    = var.db_engine_version #"5.7"
  instance_class    = var.db_instance_class # "db.t2.micro"

  db_name  = var.db_name    #"db_mysql"
  username = var.dbuser     #"admin"
  password = var.dbpassword #"password"
  # db_subnet_group_name   = aws_db_subnet_group.rds_subnet_grp.id
  # db_subnet_group_name = flatten(var.rds_subnet_group)[0] # only for list,sets and tuples.
  # vpc_security_group_ids = [aws_security_group.rds_private_sg.id]
  # vpc_security_group_ids = flatten(var.rds_security)[0]
  #   db_subnet_group_name   = var.rds_subnet_group.name
  #   vpc_security_group_ids = ["${var.rds_security}"]
  db_subnet_group_name   = var.db_subnet_group_name
  vpc_security_group_ids = ["${var.vpc_security_group_ids}"]
  identifier             = var.dbidentifier
  #   skip_final_snapshot    = true
  skip_final_snapshot = var.skip_final_snapshot

  tags = {
    Name = "db_rds"
  }
}
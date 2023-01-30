# --- networks / main.tf ---

data "aws_availability_zones" "available" {}

resource "random_integer" "random" {
  min = 1
  max = 10
}

resource "random_shuffle" "random_shufle_az" {
  input        = data.aws_availability_zones.available.names
  result_count = var.max_subnets
}

resource "aws_vpc" "main_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "main-vpc"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_subnet" "public_subnets" {
  count                   = var.public_sn_count
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.public_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = random_shuffle.random_shufle_az.result[count.index]

  tags = {
    Name = "public-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "private_subnets" {
  count             = var.private_sn_count
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.private_cidrs[count.index]
  map_public_ip_on_launch = false
  availability_zone = random_shuffle.random_shufle_az.result[count.index]
  tags = {
    Name = "private-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "rds_subnet" {
  count             = var.rds_private_sn_count
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.rds_private_cidrs[count.index]
  availability_zone = random_shuffle.random_shufle_az.result[count.index]
  tags = {
    Name = "rds-subnet-${count.index + 1}"
  }
}


# Relational Database Service Subnet Group
resource "aws_db_subnet_group" "rds_subnet_grp" {
  # count = var.rds_private_sn_count
  count       = var.aws_db_subnet_group == true ? 1 : 0
  name        = "rds_subnet_grp"
  description = "RDS database subnet group"
  # subnet_ids = [aws_subnet.sub_private_1.id, aws_subnet.sub_private_2.id]
  # subnet_ids = aws_subnet.private_subnets.*.id
  #  subnet_ids = aws_subnet.private_subnets.*.id 
  subnet_ids = aws_subnet.rds_subnet.*.id
}

# Create internet gateway, elastic IP and nat gateway

resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "main-igw"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_eip" "nat_eip" {
  vpc = true
}

resource "aws_nat_gateway" "main_igw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnets[1].id
}

# Route tables
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "public-rt"
  }
}


resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main_igw.id
}


resource "aws_route_table_association" "public_assoc" {
  count          = var.public_sn_count
  subnet_id      = aws_subnet.public_subnets.*.id[count.index]
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "private-rt"
  }
}

resource "aws_route" "web_private_route" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main_igw.id
}

resource "aws_route_table_association" "private_assoc" {
  count          = var.private_sn_count
  route_table_id = aws_route_table.private_rt.id
  subnet_id      = aws_subnet.private_subnets.*.id[count.index]
}

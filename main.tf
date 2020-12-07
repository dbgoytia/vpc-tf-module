# --------------------------------------
# AWS Backend configuration
# --------------------------------------
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      region = "us-east-1"
    }
  }
  backend "s3" {
    bucket = "691e4876-f921-0542-c9c7-0989c184fe8c-backend"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}

# --------------------------------------
# AWS Provider
# --------------------------------------
provider "aws" {
  region = var.region
}

#------------------------------------------------------------------------------
# AWS Virtual Private Network
#------------------------------------------------------------------------------
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Lab = "Network card performance"
  }
}

#------------------------------------------------------------------------------
# AWS Internet Gateway
#------------------------------------------------------------------------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}

#------------------------------------------------------------------------------
# AWS Subnets - Elastic IP
#------------------------------------------------------------------------------
resource "aws_eip" "nat_gw_eip" {
  count = var.create_natted_subnet == true ? 1 : 0
  vpc   = true
}
#------------------------------------------------------------------------------
# AWS Subnets - NAT gateway
#------------------------------------------------------------------------------
# For now, attach a single NAT Gateway to your first private subnet
resource "aws_nat_gateway" "gw" {
  count         = var.create_natted_subnet ? 1 : 0
  allocation_id = aws_eip.nat_gw_eip[0].id
  subnet_id     = aws_subnet.public_subnets[0].id
  depends_on    = [aws_subnet.public_subnets]
}


#------------------------------------------------------------------------------
# AWS Route Table (Private Routes) - As many as the number of NAT Gateways
#------------------------------------------------------------------------------
resource "aws_route_table" "private" {
  count  = var.create_natted_subnet ? 1 : 0
  vpc_id = aws_vpc.vpc.id
}

#------------------------------------------------------------------------------
# AWS Subnets - Private
#------------------------------------------------------------------------------
resource "aws_subnet" "private" {
  count             = length(var.private_subnets) > 0 ? length(var.private_subnets) : 0
  availability_zone = element(var.azs, count.index)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnets[count.index]
}

# AWS Route
resource "aws_route" "private_nat_gateway" {
  count                  = var.create_natted_subnet ? 1 : 0
  route_table_id         = element(aws_route_table.private.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.gw.*.id, count.index)

}

#------------------------------------------------------------------------------
# Route Table association (Private)
#------------------------------------------------------------------------------
resource "aws_route_table_association" "private" {
  count     = length(var.private_subnets) > 0 ? length(var.private_subnets) : 0
  subnet_id = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(
    aws_route_table.private.*.id, 0
  )
}


#------------------------------------------------------------------------------
# AWS Subnets - Public
#------------------------------------------------------------------------------
resource "aws_subnet" "public_subnets" {
  count                   = length(var.public_subnets_cidrs)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = element(var.public_subnets_cidrs, count.index)
  availability_zone       = element(var.azs, count.index)
  map_public_ip_on_launch = true
}


#------------------------------------------------------------------------------
# AWS Route Table
#------------------------------------------------------------------------------
resource "aws_route_table" "internet_route" {
  vpc_id = aws_vpc.vpc.id

  route {
    # Allow traffic from our internet gateway
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Lab = "Network card performance"
  }
}

resource "aws_main_route_table_association" "rt-assoc" {
  vpc_id         = aws_vpc.vpc.id
  route_table_id = aws_route_table.internet_route.id
}

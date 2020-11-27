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
resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc.id
}

#------------------------------------------------------------------------------
# AWS Subnets - Public
#------------------------------------------------------------------------------
resource "aws_subnet" "public_subnets" {
  count                   = length(var.public_subnets_cidrs)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = element(var.public_subnets_cidrs, count.index)
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
    gateway_id = aws_internet_gateway.ig.id
  }

  tags = {
    Lab = "Network card performance"
  }
}

resource "aws_main_route_table_association" "rt-assoc" {
  vpc_id         = aws_vpc.vpc.id
  route_table_id = aws_route_table.internet_route.id
}

#------------------------------------------------------------------------------
# VPC
#------------------------------------------------------------------------------
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge(
    {
      "Name" = format("%s", var.name)
    },
    var.tags
  )
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = merge(
    {
      "Name" = format("%s", var.name)
    },
    var.tags
  )
}

#------------------------------------------------------------------------------
# AWS Subnets - Public
#------------------------------------------------------------------------------
resource "aws_subnet" "public_subnets" {
  count                   = length(var.public_subnets_cidrs)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = element(var.public_subnets_cidrs, count.index)
  availability_zone       = element(var.azs, count.index)
  map_public_ip_on_launch = true

  tags = merge(
    {
      "Name" = format(
        "%s-public-%s",
        var.name,
        element(var.azs, count.index),
      )
    }
  )
}

#------------------------------------------------------------------------------
# Public routes
#------------------------------------------------------------------------------
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    {
      "Name" = format("%s-public", var.name)
    },
    var.tags
  )
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_main_route_table_association" "rt-assoc" {
  vpc_id         = aws_vpc.this.id
  route_table_id = aws_route_table.public.id
}

#------------------------------------------------------------------------------
# AWS Subnets - Private
#------------------------------------------------------------------------------
resource "aws_subnet" "private_subnets" {
  count             = length(var.private_subnets_cidrs) > 0 ? length(var.private_subnets_cidrs) : 0
  availability_zone = element(var.azs, count.index)
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnets_cidrs[count.index]
  tags = merge(
    {
      "Name" = format(
        "%s-private-%s",
        var.name,
        element(var.azs, count.index),
      )
    }
  )
}

#------------------------------------------------------------------------------
# Private routes - As many as number of NAT Gateways
#------------------------------------------------------------------------------
resource "aws_route_table" "private" {
  count  = local.nat_gateway_count
  vpc_id = aws_vpc.this.id
  tags = merge(
    {
      "Name" = format(
        "%s-private-%s",
        var.name,
        element(var.azs, count.index),
      )
    },
    var.tags
  )
}

resource "aws_route" "private_nat_gateway" {
  count                  = local.nat_gateway_count
  route_table_id         = element(aws_route_table.private.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.gw.*.id, count.index)
}

#------------------------------------------------------------------------------
# Route Table association (Private)
#------------------------------------------------------------------------------
resource "aws_route_table_association" "private" {
  count     = length(var.private_subnets_cidrs)
  subnet_id = element(aws_subnet.private_subnets.*.id, count.index)
  route_table_id = element(
    aws_route_table.private.*.id, count.index
  )
}

#------------------------------------------------------------------------------
# NAT Gateway
#------------------------------------------------------------------------------
resource "aws_eip" "nat_gw_eip" {
  count = local.nat_gateway_count
  vpc   = true
  tags = merge(
    {
      "Name" = format(
        "%s-%s",
        var.name,
        element(var.azs, count.index)
      )
    }
  )
}

locals {
  nat_gateway_ips = split(
    ",",
    join(",", aws_eip.nat_gw_eip.*.id),
  )
}

resource "aws_nat_gateway" "gw" {
  count = local.nat_gateway_count

  allocation_id = element(
    local.nat_gateway_ips,
    count.index
  )

  subnet_id = element(
    aws_subnet.public_subnets.*.id,
    count.index
  )

  tags = merge(
    {
      "Name" = format(
        "%s-%s",
        var.name,
        element(var.azs, count.index),
      )
    }
  )

  depends_on = [aws_subnet.public_subnets]
}



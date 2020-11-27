variable "vpc_cidr_block" {
  description = "CIDR block for our VPC"
  type        = string
}

variable "cidr_block_subnet" {
  description = "Subnet 1 CIDR block"
  type        = string
}

variable "public_subnets_cidrs" {
  type        = list
  description = "List of CIDRs to use"
}

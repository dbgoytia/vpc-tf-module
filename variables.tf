variable "vpc_cidr_block" {
  description = "CIDR block for our VPC"
  type        = string
}

variable "public_subnets_cidrs" {
  type        = list
  description = "List of CIDRs to use"
}

variable "availability_zones" {
  type        = list
  description = "List of availability zones to be used by subnets"
}
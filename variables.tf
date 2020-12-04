variable "vpc_cidr_block" {
  description = "CIDR block for our VPC"
  type        = string
}

variable "public_subnets_cidrs" {
  type        = list
  description = "List of private subnets to create in CIDR notation."
}

variable "create_natted_subnet" {
  description = "If you set this variable to true, the module will deploy a VPC NAT Gateway in front of the public subnet (Will assign an Elastic IP)"
  type        = bool
}

variable "private_subnets" {
  description = "Create a variable number of private subnets"
  type        = list
}

variable "region" {
  description = "Region to be used for deployment"
  type        = string
}
variable "vpc_cidr_block" {
  description = "CIDR block for our VPC"
  type        = string
}

variable "public_subnets_cidrs" {
  type        = list(any)
  description = "List of private subnets to create in CIDR notation."
}

variable "private_subnets_cidrs" {
  description = "List of public subnets to create in CIDR notation."
  type        = list(any)
}

variable "azs" {
  description = "List of Availability Zones to use for deployment"
  type        = list(string)
}

variable "region" {
  description = "Region to be used for deployment"
  type        = string
}

# new 
variable "name" {
  description = "Name of the VPC."
  type        = string
}

variable "tags" {
  description = "General tags to assign to the VPC."
  type        = map(any)
  default     = {}
}
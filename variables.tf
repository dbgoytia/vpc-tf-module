# VPC configuration
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

variable "name" {
  description = "Name of the VPC."
  type        = string
}

variable "tags" {
  description = "General tags to assign to the VPC."
  type        = map(any)
  default     = {}
}

# Flow log configuration 
variable "enable_flow_log" {
  description = "Wether to enable flow logs on VPC or not"
  type        = string
  default     = false
}

variable "log_destination_type" {
  description = "Type of logging destination. Valid values are: s3"
  default     = "s3"
  type        = string
}

variable "log_destination" {
  description = "Destination ARN for the VPC flow logs"
  type        = string
  default     = null
}

variable "traffic_type" {
  description = "Traffic to log in flow logs. Valud values are: ACCEPT, REJECT, ALL"
  default     = "ALL"
  type        = string
}

variable "max_aggregation_interval" {
  description = "Maximum interval of time during which a flow of packets is captured and aggregated into a flow record. Valud values: 60, 600"
  default     = 600
  type        = number
}

variable "create_flow_log_cloudwatch_log_group" {
  description = "Wether to create a cloudwatch log group or use an existing one."
  type        = bool
  default     = false
}
# VPC
region                = "us-east-1"
name                  = "test-vpc"
azs                   = ["us-east-1a", "us-east-1b", "us-east-1c"]
vpc_cidr_block        = "10.255.0.0/17"
public_subnets_cidrs  = ["10.255.96.0/21", "10.255.104.0/21", "10.255.112.0/21"] #left over 10.255.120.0/21
private_subnets_cidrs = ["10.255.0.0/19", "10.255.32.0/19", "10.255.64.0/19"]

# Flow logs
enable_flow_log      = true
log_destination_type = "s3"
log_destination      = "arn:aws:s3:::test-s3-flowlogs-dcbg"
traffic_type         = "ALL"

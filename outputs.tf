output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnets_ids" {
  description = "List with the Public Subnets ids"
  value       = aws_subnet.public_subnets.*.id
}

output "public_subnets_cidrs" {
  description = "List with the Public Subnets ids"
  value       = aws_subnet.public_subnets.*.cidr_block
}

output "private_subnets_ids" {
  description = "List with the Public Subnets ids"
  value       = aws_subnet.private_subnets.*.id
}

output "private_subnets_cidrs" {
  description = "List with the Public Subnets ids"
  value       = aws_subnet.private_subnets.*.cidr_block
}

output "default_sg" {
  description = "Output VPC default security group"
  value       = aws_vpc.vpc.default_security_group_id
}
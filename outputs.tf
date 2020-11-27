output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnets_cidrs" {
  description = "List with the Public Subnets cidrs"
  value       = aws_subnet.public_subnets.*
}
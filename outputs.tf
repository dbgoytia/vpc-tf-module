output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnets_ids" {
  description = "List with the Public Subnets ids"
  value       = sort(aws_subnet.public_subnets.*.id)[0]
}
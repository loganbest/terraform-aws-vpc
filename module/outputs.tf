# main.tf
output "vpc" {
  description = "Full VPC submodule output"
  value       = merge(module.vpc, { vpc_region = data.aws_region.current.name })
}

# natgw.tf
output "aws_eip" {
  value = aws_eip.this
}

output "aws_nat_gateway" {
  value = aws_nat_gateway.this
}

# private.tf
output "aws_subnet_private_ids" {
  value = [for subnet in aws_subnet.private : subnet.id]
}

output "aws_subnet_private" {
  value = aws_subnet.private
}

output "aws_route_table_private" {
  value = aws_route_table.private
}

output "aws_route_table_association_private" {
  value = aws_route_table_association.private
}

output "aws_route_table_ids" {
  value = [for k, v in aws_route_table.private : v.id]
}

# public.tf
output "aws_subnet_public_ids" {
  value = [for subnet in aws_subnet.public : subnet.id]
}

output "aws_subnet_public" {
  value = aws_subnet.public
}

output "aws_route_table_public" {
  value = aws_route_table.public
}

output "aws_route_table_association_public" {
  value = aws_route_table_association.public
}

output "aws_internet_gateway" {
  value = aws_internet_gateway.this
}

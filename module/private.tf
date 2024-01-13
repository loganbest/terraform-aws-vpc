# private subnets
resource "aws_subnet" "private" {
  for_each = { for k, v in local.private_subnets : k => v }

  vpc_id               = module.vpc.vpc_id
  cidr_block           = local.private_subnets[each.key]
  availability_zone_id = var.region_config.az_ids[each.key]

  tags = merge(
    module.this.tags,
    {
      Name      = "${var.name}-${var.region_config.az_ids[each.key]}-priv-subnet",
      component = "subnet"
    }
  )
}

# route table
resource "aws_route_table" "private" {
  for_each = { for k, v in var.region_config.az_ids : k => v }

  vpc_id = module.vpc.vpc_id

  tags = merge(
    module.this.tags,
    {
      Name      = "${var.name}-${each.value}-priv-rt"
      component = "rt"
    }
  )
}
# route table private subnet association
resource "aws_route_table_association" "private" {
  for_each = { for k, v in local.private_subnets : k => v }

  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private[each.key].id
}

resource "aws_route" "default" {
  for_each = { for k, v in aws_route_table.private : k => v if (length(local.public_subnets) > 0) }

  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this[each.key].id
  route_table_id         = each.value.id
}

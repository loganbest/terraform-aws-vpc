# elastic ip for natgw
resource "aws_eip" "this" {
  for_each = { for k, v in var.region_config.az_ids : k => v if (length(local.public_subnets) > 0) }

  domain = "vpc"

  tags = merge(
    module.this.tags,
    {
      Name      = "${var.name}-${each.value}-eip"
      component = "eip"
    }
  )
}
# nat gateways
resource "aws_nat_gateway" "this" {
  for_each = { for k, v in var.region_config.az_ids : k => v if (length(local.public_subnets) > 0) }

  allocation_id = aws_eip.this[each.key].id
  subnet_id     = aws_subnet.public[each.key].id

  tags = merge(
    module.this.tags,
    {
      Name      = "${var.name}-${each.value}-natgw"
      component = "natgw"
    }
  )
}

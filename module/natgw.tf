# elastic ip for private subnets
resource "aws_eip" "this" {
  for_each = { for k, v in var.region_config.az_ids : k => v }

  tags = {
    Name      = "${var.classifier}-${each.value}-eip"
    component = "eip"
  }
}
# nat gateways
resource "aws_nat_gateway" "this" {
  for_each = { for k, v in var.region_config.az_ids : k => v }

  allocation_id = aws_eip.this[each.key].id
  subnet_id     = aws_subnet.public[each.key].id

  tags = {
    Name      = "${var.classifier}-${each.value}-natgw"
    component = "natgw"
  }
}

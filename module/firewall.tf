# firewall subnets
resource "aws_subnet" "firewall" {
  for_each = { for k, v in local.firewall_subnets : k => v }

  vpc_id               = module.vpc.vpc_id
  cidr_block           = local.firewall_subnets[each.key]
  availability_zone_id = var.region_config.az_ids[each.key]

  tags = merge({
    Name      = "${var.classifier}-${var.region_config.az_ids[each.key]}-firewall-subnet",
    component = "subnet"
  })
}

# route table
resource "aws_route_table" "firewall" {
  for_each = { for k, v in var.region_config.az_ids : k => v }

  vpc_id = module.vpc.vpc_id

  tags = {
    Name      = "${var.classifier}-${each.value}-firewall-rt"
    component = "rt"
  }
}
# route table firewall subnet association
resource "aws_route_table_association" "firewall" {
  for_each = { for k, v in local.firewall_subnets : k => v }

  subnet_id      = aws_subnet.firewall[each.key].id
  route_table_id = aws_route_table.firewall[each.key].id
}

resource "aws_route" "default" {
  for_each = aws_route_table.firewall

  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this[each.key].id
  route_table_id         = each.value.id
}

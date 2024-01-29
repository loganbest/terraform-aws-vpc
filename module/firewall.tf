# firewall subnets
resource "aws_subnet" "firewall" {
  for_each = { for k, v in local.firewall_subnets : k => v if var.enable_anf }

  vpc_id               = module.vpc.vpc_id
  cidr_block           = local.firewall_subnets[each.key]
  availability_zone_id = var.region_config.az_ids[each.key]

  tags = merge(
    module.this.tags,
    {
      Name      = "${var.stage != null ? "${var.stage}-" : ""}${var.name}-${var.region_config.az_ids[each.key]}-firewall-subnet",
      component = "subnet"
    }
  )
}

# route table
resource "aws_route_table" "firewall" {
  for_each = { for k, v in var.region_config.az_ids : k => v if var.enable_anf }

  vpc_id = module.vpc.vpc_id

  tags = merge(
    module.this.tags,
    {
      Name      = "${var.stage != null ? "${var.stage}-" : ""}${var.name}-${each.value}-firewall-rt"
      component = "rt"
    }
  )
}
# route table firewall subnet association
resource "aws_route_table_association" "firewall" {
  for_each = { for k, v in local.firewall_subnets : k => v if var.enable_anf }

  subnet_id      = aws_subnet.firewall[each.key].id
  route_table_id = aws_route_table.firewall[each.key].id
}

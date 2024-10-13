# firewall subnets
resource "aws_subnet" "firewall" {
  for_each = { for k, v in local.firewall_subnets : k => v if var.enable_anf }

  vpc_id               = aws_vpc.this.id
  cidr_block           = local.firewall_subnets[each.key]
  availability_zone_id = var.region_config.az_ids[each.key]

  assign_ipv6_address_on_creation                = var.enable_ipv6 && var.firewall_subnet_assign_ipv6_address_on_creation
  enable_dns64                                   = var.enable_ipv6 && var.firewall_subnet_enable_dns64
  enable_resource_name_dns_aaaa_record_on_launch = var.enable_ipv6 && var.firewall_subnet_enable_resource_name_dns_aaaa_record_on_launch
  enable_resource_name_dns_a_record_on_launch    = var.firewall_subnet_enable_resource_name_dns_a_record_on_launch
  # each.key+3 is a result of planned space for up to 3x private, 3x firewall, 3x tgw, and 3x public subnets in that order
  ipv6_cidr_block = var.enable_ipv6 && length(local.firewall_subnets) > 0 ? cidrsubnet(aws_vpc.this.ipv6_cidr_block, 8, each.key + 3) : null
  # Not going to support ipv6 only subnets for now
  ipv6_native = false

  tags = merge(
    module.this.tags,
    {
      Name      = "${var.stage != null ? "${var.stage}-" : ""}${var.name}-${var.region_config.az_ids[each.key]}-firewall-subnet",
      component = "subnet"
    },
    var.firewall_subnet_tags
  )
}

# route table
resource "aws_route_table" "firewall" {
  for_each = { for k, v in var.region_config.az_ids : k => v if var.enable_anf }

  vpc_id = aws_vpc.this.id

  tags = merge(
    module.this.tags,
    {
      Name      = "${var.stage != null ? "${var.stage}-" : ""}${var.name}-${each.value}-firewall-rt"
      component = "rt"
    },
    var.firewall_route_table_tags
  )
}
# route table firewall subnet association
resource "aws_route_table_association" "firewall" {
  for_each = { for k, v in local.firewall_subnets : k => v if var.enable_anf }

  subnet_id      = aws_subnet.firewall[each.key].id
  route_table_id = aws_route_table.firewall[each.key].id
}

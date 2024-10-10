# private subnets
resource "aws_subnet" "private" {
  for_each = { for k, v in local.private_subnets : k => v }

  vpc_id               = aws_vpc.this.id
  cidr_block           = local.private_subnets[each.key]
  availability_zone_id = var.region_config.az_ids[each.key]

  assign_ipv6_address_on_creation                = var.enable_ipv6 && var.private_subnet_assign_ipv6_address_on_creation
  enable_dns64                                   = var.enable_ipv6 && var.private_subnet_enable_dns64
  enable_resource_name_dns_aaaa_record_on_launch = var.enable_ipv6 && var.private_subnet_enable_resource_name_dns_aaaa_record_on_launch
  enable_resource_name_dns_a_record_on_launch    = var.private_subnet_enable_resource_name_dns_a_record_on_launch
  # Private subnets always take the first 3 /64s of the VPC's /56
  ipv6_cidr_block = var.enable_ipv6 && length(local.private_subnets) > 0 ? cidrsubnet(aws_vpc.this.ipv6_cidr_block, 8, each.key) : null
  # Not going to support ipv6 only subnets for now
  ipv6_native = false

  tags = merge(
    module.this.tags,
    {
      Name      = "${var.stage != null ? "${var.stage}-" : ""}${var.name}-${var.region_config.az_ids[each.key]}-priv-subnet",
      component = "subnet"
    }
  )
}

# route table
resource "aws_route_table" "private" {
  for_each = { for k, v in var.region_config.az_ids : k => v }

  vpc_id = aws_vpc.this.id

  tags = merge(
    module.this.tags,
    {
      Name      = "${var.stage != null ? "${var.stage}-" : ""}${var.name}-${each.value}-priv-rt"
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
  for_each = { for k, v in aws_route_table.private : k => v if(length(local.private_subnets) > 0) }

  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this[each.key].id
  route_table_id         = each.value.id
}

resource "aws_route" "private_default_v6" {
  for_each = { for k, v in aws_route_table.private : k => v if(length(local.private_subnets) > 0 && var.enable_ipv6) }

  route_table_id              = aws_route_table.private[each.key].id
  destination_ipv6_cidr_block = "::/0"
  egress_only_gateway_id      = aws_egress_only_internet_gateway.this[0].id

  timeouts {
    create = "5m"
  }
}

resource "aws_route" "private_dns64" {
  for_each = { for k, v in aws_route_table.private : k => v if(length(local.private_subnets) > 0 && var.enable_ipv6 && var.private_subnet_enable_dns64) }

  route_table_id              = aws_route_table.private[each.key].id
  destination_ipv6_cidr_block = "64:ff9b::/96"
  nat_gateway_id              = aws_nat_gateway.this[each.key].id

  timeouts {
    create = "5m"
  }
}

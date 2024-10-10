# public subnets
resource "aws_subnet" "public" {
  for_each = { for k, v in local.public_subnets : k => v }

  vpc_id               = aws_vpc.this.id
  cidr_block           = local.public_subnets[each.key]
  availability_zone_id = var.region_config.az_ids[each.key]

  assign_ipv6_address_on_creation                = var.enable_ipv6 && var.public_subnet_assign_ipv6_address_on_creation
  enable_dns64                                   = var.enable_ipv6 && var.public_subnet_enable_dns64
  enable_resource_name_dns_aaaa_record_on_launch = var.enable_ipv6 && var.public_subnet_enable_resource_name_dns_aaaa_record_on_launch
  enable_resource_name_dns_a_record_on_launch    = var.public_subnet_enable_resource_name_dns_a_record_on_launch
  # each.key+9 is a result of planned space for up to 3x private, 3x firewall, 3x tgw, and 3x public subnets in that order
  ipv6_cidr_block = var.enable_ipv6 && length(local.public_subnets) > 0 ? cidrsubnet(aws_vpc.this.ipv6_cidr_block, 8, each.key + 9) : null
  # Not going to support ipv6 only subnets for now
  ipv6_native = false

  tags = merge(
    module.this.tags,
    {
      Name      = "${var.stage != null ? "${var.stage}-" : ""}${var.name}-${var.region_config.az_ids[each.key]}-pub-subnet"
      component = "subnet"
    }
  )
}

# PUBLIC SUBNETS ROUTE TABLE -----------------
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    module.this.tags,
    {
      Name      = "${var.stage != null ? "${var.stage}-" : ""}${var.name}-pub-rt"
      component = "rt"
    }
  )
}
# route table public subnet association
resource "aws_route_table_association" "public" {
  for_each = { for k, v in local.public_subnets : k => v }

  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public.id
}

# PUBLIC DEFAULT ROUTES --------------------
resource "aws_route" "public_default" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id

  timeouts {
    create = "5m"
  }
}

resource "aws_route" "public_default_v6" {
  count = var.enable_ipv6 ? 1 : 0

  route_table_id              = aws_route_table.public.id
  destination_ipv6_cidr_block = "::/0"
  gateway_id                  = aws_internet_gateway.this.id
}


# PUBLIC INTERNET GATEWAY ---------------------
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    module.this.tags,
    {
      Name      = "${var.stage != null ? "${var.stage}-" : ""}${var.name}-pub-igw"
      component = "igw"
    }
  )
}

resource "aws_egress_only_internet_gateway" "this" {
  count = var.enable_ipv6 ? 1 : 0

  vpc_id = aws_vpc.this.id

  tags = merge(
    module.this.tags,
    {
      Name      = "${var.stage != null ? "${var.stage}-" : ""}${var.name}-pub-eigw"
      component = "eigw"
    }
  )
}

# private subnets
resource "aws_subnet" "private" {
  for_each = { for k, v in local.private_subnets : k => v }

  vpc_id               = module.vpc.vpc_id
  cidr_block           = local.private_subnets[each.key]
  availability_zone_id = var.region_config.az_ids[each.key]

  tags = merge({
    Name                                            = "${var.classifier}-${var.region_config.az_ids[each.key]}-priv-subnet",
    "kubernetes.io/role/internal-elb"               = 1
    "kubernetes.io/cluster/${var.name}-eks-cluster" = "shared"
    component                                       = "subnet"
    },
    var.karpenter_selector_tag
  )
}

# route table
resource "aws_route_table" "private" {
  for_each = { for k, v in var.region_config.az_ids : k => v }

  vpc_id = module.vpc.vpc_id

  tags = {
    Name      = "${var.classifier}-${each.value}-priv-rt"
    component = "rt"
  }
}
# route table private subnet association
resource "aws_route_table_association" "private" {
  for_each = { for k, v in local.private_subnets : k => v }

  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private[each.key].id
}

resource "aws_route" "default" {
  for_each = aws_route_table.private

  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this[each.key].id
  route_table_id         = each.value.id
}

locals {
  azure_map = flatten([
    for rt in aws_route_table.private : [
      for vpc in var.azure_avd : {
        route_table_id = rt.id
        avd_cidr       = vpc.cidr
      }
    ]
  ])
}

resource "aws_route" "azure_avd" {
  for_each = { for route in local.azure_map : "${route.route_table_id}_${route.avd_cidr}" => route }

  destination_cidr_block = each.value.avd_cidr
  gateway_id             = module.vpc.vgw_id
  route_table_id         = each.value.route_table_id
}

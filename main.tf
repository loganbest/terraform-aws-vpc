data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}

data "external" "subnet_calculator" {
  program = ["python3", "${path.module}/subnet.py"]

  query = {
    base_cidr          = var.vpc_cidr
    num_azs            = length(var.region_config.az_ids)
    enable_fw_subnets  = var.enable_anf
    enable_tgw_subnets = (var.tgw_id == null) ? true : false
  }
}

locals {
  private_subnets  = (!var.enable_ipam && length(var.private_subnets_cidrs) > 0) ? var.private_subnets_cidrs : try(split(",", data.external.subnet_calculator.result["private_subnets"]), [])
  firewall_subnets = (!var.enable_ipam && length(var.firewall_subnets_cidrs) > 0) ? var.firewall_subnets_cidrs : try(split(",", data.external.subnet_calculator.result["firewall_subnets"]), [])
  tgw_subnets      = (!var.enable_ipam && length(var.tgw_subnets_cidrs) > 0) ? var.tgw_subnets_cidrs : try(split(",", data.external.subnet_calculator.result["tgw_subnets"]), [])
  public_subnets   = (!var.enable_ipam && length(var.public_subnets_cidrs) > 0) ? var.public_subnets_cidrs : try(split(",", data.external.subnet_calculator.result["public_subnets"]), [])
}

################################################################################
# VPC
################################################################################

resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr

  ipv6_ipam_pool_id   = var.enable_ipv6 ? var.ipv6_ipam_pool_id : null
  ipv6_netmask_length = var.enable_ipv6 ? var.ipv6_netmask_length : null

  instance_tenancy                     = "default"
  enable_dns_hostnames                 = var.enable_dns_hostnames
  enable_dns_support                   = var.enable_dns_support
  enable_network_address_usage_metrics = var.enable_network_address_usage_metrics

  tags = merge(
    module.this.tags,
    var.vpc_tags,
  )
}

#module "vpc" {
#source  = "terraform-aws-modules/vpc/aws"
#version = "~> 5.13.0"


#enable_flow_log             = var.enable_flow_log
#flow_log_destination_type   = var.flow_log_destination_type
#flow_log_traffic_type       = var.flow_log_traffic_type
#flow_log_destination_arn    = var.flow_log_destination_arn
#flow_log_file_format        = var.flow_log_file_format
#flow_log_per_hour_partition = var.flow_log_per_hour_partition

#tags = module.this.tags
#}

# VPC Peering with defined VPCs
resource "aws_vpc_peering_connection" "this" {
  for_each = { for vpc in var.vpc_peers : vpc.vpc_id => vpc }

  vpc_id        = aws_vpc.this.id
  peer_vpc_id   = each.value.vpc_id
  peer_owner_id = each.value.account_id
  peer_region   = each.value.region
  auto_accept   = false
}

resource "aws_vpc_peering_connection_accepter" "this" {
  for_each = aws_vpc_peering_connection.this

  vpc_peering_connection_id = each.value.id
  auto_accept               = true
}

resource "aws_vpc_peering_connection_options" "requester" {
  for_each = aws_vpc_peering_connection_accepter.this

  # As options can't be set until the connection has been accepted
  # create an explicit dependency on the accepter.
  vpc_peering_connection_id = each.value.id

  requester {
    allow_remote_vpc_dns_resolution = true
  }
}

resource "aws_vpc_peering_connection_options" "accepter" {
  for_each = aws_vpc_peering_connection_accepter.this

  vpc_peering_connection_id = each.value.id

  accepter {
    allow_remote_vpc_dns_resolution = true
  }
}

# Create a map of destination VPCs, Peering Connection IDs, and Private Route Tables
locals {
  peering_map = flatten([
    for rt in aws_route_table.private : [
      for vpc in var.vpc_peers : {
        route_table_id = rt.id
        peer_cidr      = vpc.cidr
        peering_id     = try(aws_vpc_peering_connection.this[vpc.vpc_id].id, null)
      }
    ]
  ])
}

resource "aws_route" "vpc_peering" {
  for_each = { for route in local.peering_map : "${route.route_table_id}_${route.peering_id}" => route }

  route_table_id            = each.value.route_table_id
  destination_cidr_block    = each.value.peer_cidr
  vpc_peering_connection_id = each.value.peering_id
}

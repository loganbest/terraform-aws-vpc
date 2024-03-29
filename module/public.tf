# public subnets
resource "aws_subnet" "public" {
  for_each = { for k, v in local.public_subnets : k => v }

  vpc_id               = module.vpc.vpc_id
  cidr_block           = local.public_subnets[each.key]
  availability_zone_id = var.region_config.az_ids[each.key]

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
  vpc_id = module.vpc.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

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


# PUBLIC INTERNET GATEWAY ---------------------
resource "aws_internet_gateway" "this" {
  vpc_id = module.vpc.vpc_id

  tags = merge(
    module.this.tags,
    {
      Name      = "${var.stage != null ? "${var.stage}-" : ""}${var.name}-pub-igw"
      component = "igw"
    }
  )
}

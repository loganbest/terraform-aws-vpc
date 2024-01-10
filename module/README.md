<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.8 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.8 |
| <a name="provider_aws.net_prod"></a> [aws.net\_prod](#provider\_aws.net\_prod) | ~> 5.8 |
| <a name="provider_aws.net_prod_use1"></a> [aws.net\_prod\_use1](#provider\_aws.net\_prod\_use1) | ~> 5.8 |
| <a name="provider_aws.net_prod_use2"></a> [aws.net\_prod\_use2](#provider\_aws.net\_prod\_use2) | ~> 5.8 |
| <a name="provider_external"></a> [external](#provider\_external) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | ~> 5.1.0 |

## Resources

| Name | Type |
|------|------|
| [aws_eip.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_internet_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_nat_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_route.azure_avd](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.from_netprod_use1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.from_netprod_use2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.vpc_peering](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route_table.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_subnet.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc_peering_connection.netprod_use1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection) | resource |
| [aws_vpc_peering_connection.netprod_use2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection) | resource |
| [aws_vpc_peering_connection.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection) | resource |
| [aws_vpc_peering_connection_accepter.netprod_use1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection_accepter) | resource |
| [aws_vpc_peering_connection_accepter.netprod_use2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection_accepter) | resource |
| [aws_vpc_peering_connection_accepter.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection_accepter) | resource |
| [aws_vpc_peering_connection_options.accepter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection_options) | resource |
| [aws_vpc_peering_connection_options.netprod_requester](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection_options) | resource |
| [aws_vpc_peering_connection_options.netprod_use1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection_options) | resource |
| [aws_vpc_peering_connection_options.netprod_use2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection_options) | resource |
| [aws_vpc_peering_connection_options.requester](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection_options) | resource |
| [aws_vpn_connection.azure](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpn_connection) | resource |
| [aws_vpn_connection_route.azure](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpn_connection_route) | resource |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_vpc_ipam_pool.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc_ipam_pool) | data source |
| [aws_vpc_ipam_preview_next_cidr.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc_ipam_preview_next_cidr) | data source |
| [external_external.subnet_calculator](https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/external) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_azure_avd"></a> [azure\_avd](#input\_azure\_avd) | Map of azure avd information from terragrunt globals | `any` | n/a | yes |
| <a name="input_cidr_mask_length"></a> [cidr\_mask\_length](#input\_cidr\_mask\_length) | Mask length to yank from IPAM pool | `number` | `21` | no |
| <a name="input_classifier"></a> [classifier](#input\_classifier) | Declare the environment [p: prod, d: dev, & s: staging] | `string` | n/a | yes |
| <a name="input_enable_networking_peers"></a> [enable\_networking\_peers](#input\_enable\_networking\_peers) | Enables VPC Peering with the networking prod VPCs | `bool` | `false` | no |
| <a name="input_ipam_pool"></a> [ipam\_pool](#input\_ipam\_pool) | AWS IPAM Pool Name | `string` | n/a | yes |
| <a name="input_karpenter_selector_tag"></a> [karpenter\_selector\_tag](#input\_karpenter\_selector\_tag) | Tag to find subnets and security groups that karpenter can manage | `map(string)` | `{}` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the environment | `string` | n/a | yes |
| <a name="input_network_vpc_peers"></a> [network\_vpc\_peers](#input\_network\_vpc\_peers) | List of maps defining the VPCs to peer with | <pre>list(object({<br>    vpc_id       = string<br>    account_id   = string<br>    region       = string<br>    cidr         = string<br>    route_tables = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_region_config"></a> [region\_config](#input\_region\_config) | full region config | <pre>object({<br>    enabled  = bool<br>    short    = string<br>    az_ids   = list(string)<br>    registry = string<br>  })</pre> | n/a | yes |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | string: cidr for the vpc | `string` | n/a | yes |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | Name of the VPC | `string` | n/a | yes |
| <a name="input_vpc_peers"></a> [vpc\_peers](#input\_vpc\_peers) | List of maps defining the VPCs to peer with | <pre>list(map(object({<br>    vpc_id       = string<br>    account_id   = string<br>    region       = string<br>    cidr         = string<br>    route_tables = list(string)<br>  })))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_eip"></a> [aws\_eip](#output\_aws\_eip) | natgw.tf |
| <a name="output_aws_internet_gateway"></a> [aws\_internet\_gateway](#output\_aws\_internet\_gateway) | n/a |
| <a name="output_aws_nat_gateway"></a> [aws\_nat\_gateway](#output\_aws\_nat\_gateway) | n/a |
| <a name="output_aws_route_table_association_private"></a> [aws\_route\_table\_association\_private](#output\_aws\_route\_table\_association\_private) | n/a |
| <a name="output_aws_route_table_association_public"></a> [aws\_route\_table\_association\_public](#output\_aws\_route\_table\_association\_public) | n/a |
| <a name="output_aws_route_table_ids"></a> [aws\_route\_table\_ids](#output\_aws\_route\_table\_ids) | n/a |
| <a name="output_aws_route_table_private"></a> [aws\_route\_table\_private](#output\_aws\_route\_table\_private) | n/a |
| <a name="output_aws_route_table_public"></a> [aws\_route\_table\_public](#output\_aws\_route\_table\_public) | n/a |
| <a name="output_aws_subnet_private"></a> [aws\_subnet\_private](#output\_aws\_subnet\_private) | n/a |
| <a name="output_aws_subnet_private_ids"></a> [aws\_subnet\_private\_ids](#output\_aws\_subnet\_private\_ids) | private.tf |
| <a name="output_aws_subnet_public"></a> [aws\_subnet\_public](#output\_aws\_subnet\_public) | n/a |
| <a name="output_aws_subnet_public_ids"></a> [aws\_subnet\_public\_ids](#output\_aws\_subnet\_public\_ids) | public.tf |
| <a name="output_aws_vpn_connection_route_azure"></a> [aws\_vpn\_connection\_route\_azure](#output\_aws\_vpn\_connection\_route\_azure) | n/a |
| <a name="output_vpc"></a> [vpc](#output\_vpc) | Full VPC submodule output |
<!-- END_TF_DOCS -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.8 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.9.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | ~> 5.1.0 |

## Resources

| Name | Type |
|------|------|
| [aws_eip.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_internet_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_nat_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_route_table.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_subnet.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpn_connection.azure](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpn_connection) | resource |
| [aws_vpn_connection_route.azure](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpn_connection_route) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zone_ids"></a> [availability\_zone\_ids](#input\_availability\_zone\_ids) | List of AZ IDs for VPC subnets | `list(string)` | n/a | yes |
| <a name="input_azure_avd"></a> [azure\_avd](#input\_azure\_avd) | Map of azure avd information from terragrunt globals | `any` | n/a | yes |
| <a name="input_classifier"></a> [classifier](#input\_classifier) | Declare the environment [p: prod, d: dev, & s: staging] | `string` | n/a | yes |
| <a name="input_azure_avd_cidr"></a> [azure\_avd\_cidr](#input\_azure\_avd\_cidr) | Azure AVD cidr values for both primary and DR | `string` | n/a | yes |
| <a name="input_classifier"></a> [classifier](#input\_classifier) | Declare the environment [p: prod, d: dev, & s: staging] | `string` | n/a | yes |
| <a name="input_customer_gateway_ip"></a> [customer\_gateway\_ip](#input\_customer\_gateway\_ip) | string: customer gateway ip | `string` | n/a | yes |
| <a name="input_karpenter_selector_tag"></a> [karpenter\_selector\_tag](#input\_karpenter\_selector\_tag) | Tag to find subnets and security groups that karpenter can manage | `map(string)` | `{}` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the environment | `string` | n/a | yes |
| <a name="input_private_subnets_cidrs"></a> [private\_subnets\_cidrs](#input\_private\_subnets\_cidrs) | list of strings: declare 3 cidrs for the private subnets | `list(string)` | n/a | yes |
| <a name="input_public_subnets_cidrs"></a> [public\_subnets\_cidrs](#input\_public\_subnets\_cidrs) | list of strings: declare 3 cidrs for the public subnets | `list(string)` | n/a | yes |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | string: cidr for the vpc | `string` | n/a | yes |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | Name of the VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_eip"></a> [aws\_eip](#output\_aws\_eip) | natgw.tf |
| <a name="output_aws_internet_gateway"></a> [aws\_internet\_gateway](#output\_aws\_internet\_gateway) | n/a |
| <a name="output_aws_nat_gateway"></a> [aws\_nat\_gateway](#output\_aws\_nat\_gateway) | n/a |
| <a name="output_aws_route_table_association_private"></a> [aws\_route\_table\_association\_private](#output\_aws\_route\_table\_association\_private) | n/a |
| <a name="output_aws_route_table_association_public"></a> [aws\_route\_table\_association\_public](#output\_aws\_route\_table\_association\_public) | n/a |
| <a name="output_aws_route_table_ids"></a> [aws\_route\_table\_ids](#output\_aws\_route\_table\_ids) | n/a |
| <a name="output_aws_route_table_private"></a> [aws\_route\_table\_private](#output\_aws\_route\_table\_private) | n/a |
| <a name="output_aws_route_table_public"></a> [aws\_route\_table\_public](#output\_aws\_route\_table\_public) | n/a |
| <a name="output_aws_subnet_private"></a> [aws\_subnet\_private](#output\_aws\_subnet\_private) | n/a |
| <a name="output_aws_subnet_private_ids"></a> [aws\_subnet\_private\_ids](#output\_aws\_subnet\_private\_ids) | private.tf |
| <a name="output_aws_subnet_public"></a> [aws\_subnet\_public](#output\_aws\_subnet\_public) | n/a |
| <a name="output_aws_subnet_public_ids"></a> [aws\_subnet\_public\_ids](#output\_aws\_subnet\_public\_ids) | public.tf |
| <a name="output_aws_vpn_connection_route_azure"></a> [aws\_vpn\_connection\_route\_azure](#output\_aws\_vpn\_connection\_route\_azure) | n/a |
| <a name="output_vpc"></a> [vpc](#output\_vpc) | Full VPC submodule output |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

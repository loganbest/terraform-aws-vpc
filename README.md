# terraform-aws-vpc

I created this module to have an all-in-one VPC module that supports IPAM and AWS Network Firewall out of the box using best practices.

``` hcl
"enter example code here from terragrunt"
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.8 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.50 |
| <a name="requirement_external"></a> [external](#requirement\_external) | ~> 2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.50 |
| <a name="provider_external"></a> [external](#provider\_external) | ~> 2.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_this"></a> [this](#module\_this) | cloudposse/label/null | 0.25.0 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | ~> 5.9.0 |

## Resources

| Name | Type |
|------|------|
| [aws_eip.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_internet_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_nat_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_route.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.vpc_peering](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route_table.firewall](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.firewall](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_subnet.firewall](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc_peering_connection.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection) | resource |
| [aws_vpc_peering_connection_accepter.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection_accepter) | resource |
| [aws_vpc_peering_connection_options.accepter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection_options) | resource |
| [aws_vpc_peering_connection_options.requester](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection_options) | resource |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_vpc_ipam_pool.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc_ipam_pool) | data source |
| [aws_vpc_ipam_preview_next_cidr.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc_ipam_preview_next_cidr) | data source |
| [external_external.subnet_calculator](https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/external) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_tag_map"></a> [additional\_tag\_map](#input\_additional\_tag\_map) | Additional key-value pairs to add to each map in `tags_as_list_of_maps`. Not added to `tags` or `id`.<br>This is for some rare cases where resources want additional configuration of tags<br>and therefore take a list of maps with tag key, value, and additional configuration. | `map(string)` | `{}` | no |
| <a name="input_attributes"></a> [attributes](#input\_attributes) | ID element. Additional attributes (e.g. `workers` or `cluster`) to add to `id`,<br>in the order they appear in the list. New attributes are appended to the<br>end of the list. The elements of the list are joined by the `delimiter`<br>and treated as a single ID element. | `list(string)` | `[]` | no |
| <a name="input_cidr_mask_length"></a> [cidr\_mask\_length](#input\_cidr\_mask\_length) | Mask length to yank from IPAM pool | `number` | `21` | no |
| <a name="input_context"></a> [context](#input\_context) | Single object for setting entire context at once.<br>See description of individual variables for details.<br>Leave string and numeric variables as `null` to use default value.<br>Individual variable settings (non-null) override settings in context object,<br>except for attributes, tags, and additional\_tag\_map, which are merged. | `any` | <pre>{<br>  "additional_tag_map": {},<br>  "attributes": [],<br>  "delimiter": null,<br>  "descriptor_formats": {},<br>  "enabled": true,<br>  "environment": null,<br>  "id_length_limit": null,<br>  "label_key_case": null,<br>  "label_order": [],<br>  "label_value_case": null,<br>  "labels_as_tags": [<br>    "unset"<br>  ],<br>  "name": null,<br>  "namespace": null,<br>  "regex_replace_chars": null,<br>  "stage": null,<br>  "tags": {},<br>  "tenant": null<br>}</pre> | no |
| <a name="input_default_security_group_egress"></a> [default\_security\_group\_egress](#input\_default\_security\_group\_egress) | Egress rules for the VPC Default Security Group. By default set for allow nothing | `list(map(string))` | `[]` | no |
| <a name="input_default_security_group_ingress"></a> [default\_security\_group\_ingress](#input\_default\_security\_group\_ingress) | Ingress rules for the VPC Default Security Group. By default set for allow nothing | `list(map(string))` | `[]` | no |
| <a name="input_delimiter"></a> [delimiter](#input\_delimiter) | Delimiter to be used between ID elements.<br>Defaults to `-` (hyphen). Set to `""` to use no delimiter at all. | `string` | `null` | no |
| <a name="input_descriptor_formats"></a> [descriptor\_formats](#input\_descriptor\_formats) | Describe additional descriptors to be output in the `descriptors` output map.<br>Map of maps. Keys are names of descriptors. Values are maps of the form<br>`{<br>   format = string<br>   labels = list(string)<br>}`<br>(Type is `any` so the map values can later be enhanced to provide additional options.)<br>`format` is a Terraform format string to be passed to the `format()` function.<br>`labels` is a list of labels, in order, to pass to `format()` function.<br>Label values will be normalized before being passed to `format()` so they will be<br>identical to how they appear in `id`.<br>Default is `{}` (`descriptors` output will be empty). | `any` | `{}` | no |
| <a name="input_enable_anf"></a> [enable\_anf](#input\_enable\_anf) | Whether to enable the components needed for using AWS Network Firewall (Default: false) | `bool` | `false` | no |
| <a name="input_enable_ipam"></a> [enable\_ipam](#input\_enable\_ipam) | Whether to enable the AWS VPC IPAM or not in CIDR selection (Default: false) | `bool` | `false` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Set to false to prevent the module from creating any resources | `bool` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT' | `string` | `null` | no |
| <a name="input_firewall_subnets_cidrs"></a> [firewall\_subnets\_cidrs](#input\_firewall\_subnets\_cidrs) | list of strings: declare cidrs for the firewall subnets | `list(string)` | `[]` | no |
| <a name="input_id_length_limit"></a> [id\_length\_limit](#input\_id\_length\_limit) | Limit `id` to this many characters (minimum 6).<br>Set to `0` for unlimited length.<br>Set to `null` for keep the existing setting, which defaults to `0`.<br>Does not affect `id_full`. | `number` | `null` | no |
| <a name="input_ipam_pool"></a> [ipam\_pool](#input\_ipam\_pool) | AWS IPAM Pool Name | `string` | `null` | no |
| <a name="input_label_key_case"></a> [label\_key\_case](#input\_label\_key\_case) | Controls the letter case of the `tags` keys (label names) for tags generated by this module.<br>Does not affect keys of tags passed in via the `tags` input.<br>Possible values: `lower`, `title`, `upper`.<br>Default value: `title`. | `string` | `null` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | The order in which the labels (ID elements) appear in the `id`.<br>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br>You can omit any of the 6 labels ("tenant" is the 6th), but at least one must be present. | `list(string)` | `null` | no |
| <a name="input_label_value_case"></a> [label\_value\_case](#input\_label\_value\_case) | Controls the letter case of ID elements (labels) as included in `id`,<br>set as tag values, and output by this module individually.<br>Does not affect values of tags passed in via the `tags` input.<br>Possible values: `lower`, `title`, `upper` and `none` (no transformation).<br>Set this to `title` and set `delimiter` to `""` to yield Pascal Case IDs.<br>Default value: `lower`. | `string` | `null` | no |
| <a name="input_labels_as_tags"></a> [labels\_as\_tags](#input\_labels\_as\_tags) | Set of labels (ID elements) to include as tags in the `tags` output.<br>Default is to include all labels.<br>Tags with empty values will not be included in the `tags` output.<br>Set to `[]` to suppress all generated tags.<br>**Notes:**<br>  The value of the `name` tag, if included, will be the `id`, not the `name`.<br>  Unlike other `null-label` inputs, the initial setting of `labels_as_tags` cannot be<br>  changed in later chained modules. Attempts to change it will be silently ignored. | `set(string)` | <pre>[<br>  "default"<br>]</pre> | no |
| <a name="input_name"></a> [name](#input\_name) | ID element. Usually the component or solution name, e.g. 'app' or 'jenkins'.<br>This is the only ID element not also included as a `tag`.<br>The "name" tag is set to the full `id` string. There is no tag with the value of the `name` input. | `string` | `null` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | ID element. Usually an abbreviation of your organization name, e.g. 'eg' or 'cp', to help ensure generated IDs are globally unique | `string` | `null` | no |
| <a name="input_private_subnets_cidrs"></a> [private\_subnets\_cidrs](#input\_private\_subnets\_cidrs) | list of strings: declare cidrs for the private subnets | `list(string)` | `[]` | no |
| <a name="input_public_subnets_cidrs"></a> [public\_subnets\_cidrs](#input\_public\_subnets\_cidrs) | list of strings: declare cidrs for the public subnets | `list(string)` | `[]` | no |
| <a name="input_regex_replace_chars"></a> [regex\_replace\_chars](#input\_regex\_replace\_chars) | Terraform regular expression (regex) string.<br>Characters matching the regex will be removed from the ID elements.<br>If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits. | `string` | `null` | no |
| <a name="input_region_config"></a> [region\_config](#input\_region\_config) | full region config | <pre>object({<br>    enabled = bool<br>    short   = string<br>    az_ids  = list(string)<br>  })</pre> | n/a | yes |
| <a name="input_stage"></a> [stage](#input\_stage) | ID element. Usually used to indicate role, e.g. 'prod', 'staging', 'source', 'build', 'test', 'deploy', 'release' | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags (e.g. `{'BusinessUnit': 'XYZ'}`).<br>Neither the tag keys nor the tag values will be modified by this module. | `map(string)` | `{}` | no |
| <a name="input_tenant"></a> [tenant](#input\_tenant) | ID element \_(Rarely used, not included by default)\_. A customer identifier, indicating who this instance of a resource is for | `string` | `null` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | string: cidr for the vpc | `string` | n/a | yes |
| <a name="input_vpc_peers"></a> [vpc\_peers](#input\_vpc\_peers) | List of maps defining the VPCs to peer with | <pre>list(map(object({<br>    vpc_id       = string<br>    account_id   = string<br>    region       = string<br>    cidr         = string<br>    route_tables = list(string)<br>  })))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_eip"></a> [aws\_eip](#output\_aws\_eip) | natgw.tf |
| <a name="output_aws_firewall_route_table_ids"></a> [aws\_firewall\_route\_table\_ids](#output\_aws\_firewall\_route\_table\_ids) | n/a |
| <a name="output_aws_internet_gateway"></a> [aws\_internet\_gateway](#output\_aws\_internet\_gateway) | n/a |
| <a name="output_aws_nat_gateway"></a> [aws\_nat\_gateway](#output\_aws\_nat\_gateway) | n/a |
| <a name="output_aws_route_table_association_firewall"></a> [aws\_route\_table\_association\_firewall](#output\_aws\_route\_table\_association\_firewall) | n/a |
| <a name="output_aws_route_table_association_private"></a> [aws\_route\_table\_association\_private](#output\_aws\_route\_table\_association\_private) | n/a |
| <a name="output_aws_route_table_association_public"></a> [aws\_route\_table\_association\_public](#output\_aws\_route\_table\_association\_public) | n/a |
| <a name="output_aws_route_table_firewall"></a> [aws\_route\_table\_firewall](#output\_aws\_route\_table\_firewall) | n/a |
| <a name="output_aws_route_table_ids"></a> [aws\_route\_table\_ids](#output\_aws\_route\_table\_ids) | n/a |
| <a name="output_aws_route_table_private"></a> [aws\_route\_table\_private](#output\_aws\_route\_table\_private) | n/a |
| <a name="output_aws_route_table_public"></a> [aws\_route\_table\_public](#output\_aws\_route\_table\_public) | n/a |
| <a name="output_aws_subnet_firewall"></a> [aws\_subnet\_firewall](#output\_aws\_subnet\_firewall) | n/a |
| <a name="output_aws_subnet_firewall_ids"></a> [aws\_subnet\_firewall\_ids](#output\_aws\_subnet\_firewall\_ids) | firewall.tf |
| <a name="output_aws_subnet_private"></a> [aws\_subnet\_private](#output\_aws\_subnet\_private) | n/a |
| <a name="output_aws_subnet_private_ids"></a> [aws\_subnet\_private\_ids](#output\_aws\_subnet\_private\_ids) | private.tf |
| <a name="output_aws_subnet_public"></a> [aws\_subnet\_public](#output\_aws\_subnet\_public) | n/a |
| <a name="output_aws_subnet_public_ids"></a> [aws\_subnet\_public\_ids](#output\_aws\_subnet\_public\_ids) | public.tf |
| <a name="output_vpc"></a> [vpc](#output\_vpc) | Full VPC submodule output |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

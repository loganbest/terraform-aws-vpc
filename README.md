# terraform-aws-vpc

I created this module to have an all-in-one VPC module that supports IPAM and AWS Network Firewall out of the box using best practices. Due to how Terraform and AWS work, there's race conditions on both sides. This module assumes a static IPv4 Address will be provided, and IPv6 will be provided from AWS IPAM. This means that if you use IPAM for IPv4 as well, you'll need to allocate that CIDR outside of this module and pass it in as a static CIDR. 

``` hcl
terraform {
  source = "git@github.com:loganbest/terraform-aws-vpc.git//?ref=x.x.x"
}

locals {
  global  = read_terragrunt_config(find_in_parent_folders("global.hcl")).locals
  region  = read_terragrunt_config(find_in_parent_folders("region.hcl")).locals
  account = read_terragrunt_config(find_in_parent_folders("account.hcl")).locals
  mocks   = read_terragrunt_config(find_in_parent_folders("mocks.hcl")).locals
  vpc   = read_terragrunt_config(find_in_parent_folders("vpc.hcl")).locals
}

dependency "ipam" {
  config_path = find_in_parent_folders("ipam")

  skip_outputs = local.mocks._skip_outputs
  mock_outputs = local.mocks.ipam
}

dependency "flowlogs" {
  config_path = "${find_in_parent_folders(local.region.region)}/s3/flow_logs"

  skip_outputs = local.mocks._skip_outputs
  mock_outputs = local.mocks.s3
}

inputs = {
  stage = local.account.stage
  name = "shared-001"
  vpc_name = local.vpc.vpc_name
  vpc_cidr = dependency.ipam.outputs.ipv4_cidr
  enable_ipv6 = true
  ipv6_ipam_pool_id = dependency.ipam.outputs.ipv6_pool_id
  ipam_public_scope_id = dependency.ipam.outputs.ipam_public_scope_id
  ipv6_netmask_length = 56

  region_config = local.global.aws_operating_regions[local.region.region]

  enable_flow_log = true
  flow_log_destination_type   = "s3"
  flow_log_traffic_type       = "ALL"
  flow_log_destination_arn    = dependency.flowlogs.outputs.bucket_arn
  flow_log_file_format        = "parquet"
  flow_log_per_hour_partition = true
}

include {
  path = find_in_parent_folders("provider.hcl")
}
```

<!-- BEGIN_TF_DOCS -->
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

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.flow_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_default_security_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_security_group) | resource |
| [aws_egress_only_internet_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/egress_only_internet_gateway) | resource |
| [aws_eip.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_flow_log.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/flow_log) | resource |
| [aws_iam_policy.vpc_flow_log_cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.vpc_flow_log_cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.vpc_flow_log_cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_internet_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_nat_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_route.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.private_default_v6](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.private_dns64](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.public_default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.public_default_v6](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.to_tgw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.vpc_peering](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route_table.firewall](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.tgw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.firewall](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.tgw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_subnet.firewall](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.tgw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_vpc_peering_connection.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection) | resource |
| [aws_vpc_peering_connection_accepter.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection_accepter) | resource |
| [aws_vpc_peering_connection_options.accepter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection_options) | resource |
| [aws_vpc_peering_connection_options.requester](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection_options) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.flow_log_cloudwatch_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.vpc_flow_log_cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [external_external.subnet_calculator](https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/external) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_tag_map"></a> [additional\_tag\_map](#input\_additional\_tag\_map) | Additional key-value pairs to add to each map in `tags_as_list_of_maps`. Not added to `tags` or `id`.<br>This is for some rare cases where resources want additional configuration of tags<br>and therefore take a list of maps with tag key, value, and additional configuration. | `map(string)` | `{}` | no |
| <a name="input_attributes"></a> [attributes](#input\_attributes) | ID element. Additional attributes (e.g. `workers` or `cluster`) to add to `id`,<br>in the order they appear in the list. New attributes are appended to the<br>end of the list. The elements of the list are joined by the `delimiter`<br>and treated as a single ID element. | `list(string)` | `[]` | no |
| <a name="input_context"></a> [context](#input\_context) | Single object for setting entire context at once.<br>See description of individual variables for details.<br>Leave string and numeric variables as `null` to use default value.<br>Individual variable settings (non-null) override settings in context object,<br>except for attributes, tags, and additional\_tag\_map, which are merged. | `any` | <pre>{<br>  "additional_tag_map": {},<br>  "attributes": [],<br>  "delimiter": null,<br>  "descriptor_formats": {},<br>  "enabled": true,<br>  "environment": null,<br>  "id_length_limit": null,<br>  "label_key_case": null,<br>  "label_order": [],<br>  "label_value_case": null,<br>  "labels_as_tags": [<br>    "unset"<br>  ],<br>  "name": null,<br>  "namespace": null,<br>  "regex_replace_chars": null,<br>  "stage": null,<br>  "tags": {},<br>  "tenant": null<br>}</pre> | no |
| <a name="input_create_flow_log_cloudwatch_iam_role"></a> [create\_flow\_log\_cloudwatch\_iam\_role](#input\_create\_flow\_log\_cloudwatch\_iam\_role) | Whether to create IAM role for VPC Flow Logs | `bool` | `false` | no |
| <a name="input_create_flow_log_cloudwatch_log_group"></a> [create\_flow\_log\_cloudwatch\_log\_group](#input\_create\_flow\_log\_cloudwatch\_log\_group) | Whether to create CloudWatch log group for VPC Flow Logs | `bool` | `false` | no |
| <a name="input_delimiter"></a> [delimiter](#input\_delimiter) | Delimiter to be used between ID elements.<br>Defaults to `-` (hyphen). Set to `""` to use no delimiter at all. | `string` | `null` | no |
| <a name="input_descriptor_formats"></a> [descriptor\_formats](#input\_descriptor\_formats) | Describe additional descriptors to be output in the `descriptors` output map.<br>Map of maps. Keys are names of descriptors. Values are maps of the form<br>`{<br>   format = string<br>   labels = list(string)<br>}`<br>(Type is `any` so the map values can later be enhanced to provide additional options.)<br>`format` is a Terraform format string to be passed to the `format()` function.<br>`labels` is a list of labels, in order, to pass to `format()` function.<br>Label values will be normalized before being passed to `format()` so they will be<br>identical to how they appear in `id`.<br>Default is `{}` (`descriptors` output will be empty). | `any` | `{}` | no |
| <a name="input_enable_anf"></a> [enable\_anf](#input\_enable\_anf) | Whether to enable the components needed for using AWS Network Firewall (Default: false) | `bool` | `false` | no |
| <a name="input_enable_dns_hostnames"></a> [enable\_dns\_hostnames](#input\_enable\_dns\_hostnames) | Whether to enable DNS Hostnames | `bool` | `true` | no |
| <a name="input_enable_dns_support"></a> [enable\_dns\_support](#input\_enable\_dns\_support) | Whether to enable DNS Support | `bool` | `true` | no |
| <a name="input_enable_flow_log"></a> [enable\_flow\_log](#input\_enable\_flow\_log) | Whether or not to enable VPC Flow Logs | `bool` | `false` | no |
| <a name="input_enable_ipam"></a> [enable\_ipam](#input\_enable\_ipam) | Whether to enable the AWS VPC IPAM or not in CIDR selection (Default: false) | `bool` | `false` | no |
| <a name="input_enable_ipv6"></a> [enable\_ipv6](#input\_enable\_ipv6) | Bool to enable IPv6 in the VPC | `bool` | `false` | no |
| <a name="input_enable_network_address_usage_metrics"></a> [enable\_network\_address\_usage\_metrics](#input\_enable\_network\_address\_usage\_metrics) | Whether to enable Network Address Usage Metrics | `bool` | `true` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Set to false to prevent the module from creating any resources | `bool` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT' | `string` | `null` | no |
| <a name="input_firewall_subnet_assign_ipv6_address_on_creation"></a> [firewall\_subnet\_assign\_ipv6\_address\_on\_creation](#input\_firewall\_subnet\_assign\_ipv6\_address\_on\_creation) | Specify true to indicate that network interfaces created in the specified subnet should be assigned an IPv6 address. | `bool` | `true` | no |
| <a name="input_firewall_subnet_enable_dns64"></a> [firewall\_subnet\_enable\_dns64](#input\_firewall\_subnet\_enable\_dns64) | Indicates whether DNS queries made to the Amazon-provided DNS Resolver in this subnet should return synthetic IPv6 addresses for IPv4-only destinations. | `bool` | `true` | no |
| <a name="input_firewall_subnet_enable_resource_name_dns_a_record_on_launch"></a> [firewall\_subnet\_enable\_resource\_name\_dns\_a\_record\_on\_launch](#input\_firewall\_subnet\_enable\_resource\_name\_dns\_a\_record\_on\_launch) | Indicates whether to respond to DNS queries for instance hostnames with DNS A records | `bool` | `false` | no |
| <a name="input_firewall_subnet_enable_resource_name_dns_aaaa_record_on_launch"></a> [firewall\_subnet\_enable\_resource\_name\_dns\_aaaa\_record\_on\_launch](#input\_firewall\_subnet\_enable\_resource\_name\_dns\_aaaa\_record\_on\_launch) | Indicates whether to respond to DNS queries for instance hostnames with DNS AAAA records. | `bool` | `false` | no |
| <a name="input_firewall_subnets_cidrs"></a> [firewall\_subnets\_cidrs](#input\_firewall\_subnets\_cidrs) | list of strings: declare cidrs for the firewall subnets | `list(string)` | `[]` | no |
| <a name="input_flow_log_cloudwatch_iam_role_arn"></a> [flow\_log\_cloudwatch\_iam\_role\_arn](#input\_flow\_log\_cloudwatch\_iam\_role\_arn) | The ARN for the IAM role that's used to post flow logs to a CloudWatch Logs log group. When flow\_log\_destination\_arn is set to ARN of Cloudwatch Logs, this argument needs to be provided | `string` | `""` | no |
| <a name="input_flow_log_cloudwatch_log_group_class"></a> [flow\_log\_cloudwatch\_log\_group\_class](#input\_flow\_log\_cloudwatch\_log\_group\_class) | Specified the log class of the log group. Possible values are: STANDARD or INFREQUENT\_ACCESS | `string` | `null` | no |
| <a name="input_flow_log_cloudwatch_log_group_kms_key_id"></a> [flow\_log\_cloudwatch\_log\_group\_kms\_key\_id](#input\_flow\_log\_cloudwatch\_log\_group\_kms\_key\_id) | The ARN of the KMS Key to use when encrypting log data for VPC flow logs | `string` | `null` | no |
| <a name="input_flow_log_cloudwatch_log_group_name_prefix"></a> [flow\_log\_cloudwatch\_log\_group\_name\_prefix](#input\_flow\_log\_cloudwatch\_log\_group\_name\_prefix) | Specifies the name prefix of CloudWatch Log Group for VPC flow logs | `string` | `"/aws/vpc-flow-log/"` | no |
| <a name="input_flow_log_cloudwatch_log_group_name_suffix"></a> [flow\_log\_cloudwatch\_log\_group\_name\_suffix](#input\_flow\_log\_cloudwatch\_log\_group\_name\_suffix) | Specifies the name suffix of CloudWatch Log Group for VPC flow logs | `string` | `""` | no |
| <a name="input_flow_log_cloudwatch_log_group_retention_in_days"></a> [flow\_log\_cloudwatch\_log\_group\_retention\_in\_days](#input\_flow\_log\_cloudwatch\_log\_group\_retention\_in\_days) | Specifies the number of days you want to retain log events in the specified log group for VPC flow logs | `number` | `null` | no |
| <a name="input_flow_log_cloudwatch_log_group_skip_destroy"></a> [flow\_log\_cloudwatch\_log\_group\_skip\_destroy](#input\_flow\_log\_cloudwatch\_log\_group\_skip\_destroy) | Set to true if you do not wish the log group (and any logs it may contain) to be deleted at destroy time, and instead just remove the log group from the Terraform state | `bool` | `false` | no |
| <a name="input_flow_log_deliver_cross_account_role"></a> [flow\_log\_deliver\_cross\_account\_role](#input\_flow\_log\_deliver\_cross\_account\_role) | (Optional) ARN of the IAM role that allows Amazon EC2 to publish flow logs across accounts. | `string` | `null` | no |
| <a name="input_flow_log_destination_arn"></a> [flow\_log\_destination\_arn](#input\_flow\_log\_destination\_arn) | The ARN of the CloudWatch log group or S3 bucket where VPC Flow Logs will be pushed. If this ARN is a S3 bucket the appropriate permissions need to be set on that bucket's policy. When create\_flow\_log\_cloudwatch\_log\_group is set to false this argument must be provided | `string` | `""` | no |
| <a name="input_flow_log_destination_type"></a> [flow\_log\_destination\_type](#input\_flow\_log\_destination\_type) | Type of flow log destination. Can be s3, kinesis-data-firehose or cloud-watch-logs | `string` | `"cloud-watch-logs"` | no |
| <a name="input_flow_log_file_format"></a> [flow\_log\_file\_format](#input\_flow\_log\_file\_format) | (Optional) The format for the flow log. Valid values: `plain-text`, `parquet` | `string` | `null` | no |
| <a name="input_flow_log_hive_compatible_partitions"></a> [flow\_log\_hive\_compatible\_partitions](#input\_flow\_log\_hive\_compatible\_partitions) | (Optional) Indicates whether to use Hive-compatible prefixes for flow logs stored in Amazon S3 | `bool` | `false` | no |
| <a name="input_flow_log_log_format"></a> [flow\_log\_log\_format](#input\_flow\_log\_log\_format) | The fields to include in the flow log record, in the order in which they should appear | `string` | `null` | no |
| <a name="input_flow_log_max_aggregation_interval"></a> [flow\_log\_max\_aggregation\_interval](#input\_flow\_log\_max\_aggregation\_interval) | The maximum interval of time during which a flow of packets is captured and aggregated into a flow log record. Valid Values: `60` seconds or `600` seconds | `number` | `600` | no |
| <a name="input_flow_log_per_hour_partition"></a> [flow\_log\_per\_hour\_partition](#input\_flow\_log\_per\_hour\_partition) | (Optional) Indicates whether to partition the flow log per hour. This reduces the cost and response time for queries | `bool` | `false` | no |
| <a name="input_flow_log_traffic_type"></a> [flow\_log\_traffic\_type](#input\_flow\_log\_traffic\_type) | The type of traffic to capture. Valid values: ACCEPT, REJECT, ALL | `string` | `"ALL"` | no |
| <a name="input_id_length_limit"></a> [id\_length\_limit](#input\_id\_length\_limit) | Limit `id` to this many characters (minimum 6).<br>Set to `0` for unlimited length.<br>Set to `null` for keep the existing setting, which defaults to `0`.<br>Does not affect `id_full`. | `number` | `null` | no |
| <a name="input_ipv6_ipam_pool_id"></a> [ipv6\_ipam\_pool\_id](#input\_ipv6\_ipam\_pool\_id) | IPAM Pool ID to use for IPv6 subnet assignment | `string` | `null` | no |
| <a name="input_ipv6_netmask_length"></a> [ipv6\_netmask\_length](#input\_ipv6\_netmask\_length) | IPv6 Netmask Length to use when getting a v6 assignment from IPAM | `number` | `56` | no |
| <a name="input_label_key_case"></a> [label\_key\_case](#input\_label\_key\_case) | Controls the letter case of the `tags` keys (label names) for tags generated by this module.<br>Does not affect keys of tags passed in via the `tags` input.<br>Possible values: `lower`, `title`, `upper`.<br>Default value: `title`. | `string` | `null` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | The order in which the labels (ID elements) appear in the `id`.<br>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br>You can omit any of the 6 labels ("tenant" is the 6th), but at least one must be present. | `list(string)` | `null` | no |
| <a name="input_label_value_case"></a> [label\_value\_case](#input\_label\_value\_case) | Controls the letter case of ID elements (labels) as included in `id`,<br>set as tag values, and output by this module individually.<br>Does not affect values of tags passed in via the `tags` input.<br>Possible values: `lower`, `title`, `upper` and `none` (no transformation).<br>Set this to `title` and set `delimiter` to `""` to yield Pascal Case IDs.<br>Default value: `lower`. | `string` | `null` | no |
| <a name="input_labels_as_tags"></a> [labels\_as\_tags](#input\_labels\_as\_tags) | Set of labels (ID elements) to include as tags in the `tags` output.<br>Default is to include all labels.<br>Tags with empty values will not be included in the `tags` output.<br>Set to `[]` to suppress all generated tags.<br>**Notes:**<br>  The value of the `name` tag, if included, will be the `id`, not the `name`.<br>  Unlike other `null-label` inputs, the initial setting of `labels_as_tags` cannot be<br>  changed in later chained modules. Attempts to change it will be silently ignored. | `set(string)` | <pre>[<br>  "default"<br>]</pre> | no |
| <a name="input_name"></a> [name](#input\_name) | ID element. Usually the component or solution name, e.g. 'app' or 'jenkins'.<br>This is the only ID element not also included as a `tag`.<br>The "name" tag is set to the full `id` string. There is no tag with the value of the `name` input. | `string` | `null` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | ID element. Usually an abbreviation of your organization name, e.g. 'eg' or 'cp', to help ensure generated IDs are globally unique | `string` | `null` | no |
| <a name="input_private_subnet_assign_ipv6_address_on_creation"></a> [private\_subnet\_assign\_ipv6\_address\_on\_creation](#input\_private\_subnet\_assign\_ipv6\_address\_on\_creation) | Specify true to indicate that network interfaces created in the specified subnet should be assigned an IPv6 address. | `bool` | `true` | no |
| <a name="input_private_subnet_enable_dns64"></a> [private\_subnet\_enable\_dns64](#input\_private\_subnet\_enable\_dns64) | Indicates whether DNS queries made to the Amazon-provided DNS Resolver in this subnet should return synthetic IPv6 addresses for IPv4-only destinations. | `bool` | `true` | no |
| <a name="input_private_subnet_enable_resource_name_dns_a_record_on_launch"></a> [private\_subnet\_enable\_resource\_name\_dns\_a\_record\_on\_launch](#input\_private\_subnet\_enable\_resource\_name\_dns\_a\_record\_on\_launch) | Indicates whether to respond to DNS queries for instance hostnames with DNS A records | `bool` | `false` | no |
| <a name="input_private_subnet_enable_resource_name_dns_aaaa_record_on_launch"></a> [private\_subnet\_enable\_resource\_name\_dns\_aaaa\_record\_on\_launch](#input\_private\_subnet\_enable\_resource\_name\_dns\_aaaa\_record\_on\_launch) | Indicates whether to respond to DNS queries for instance hostnames with DNS AAAA records. | `bool` | `false` | no |
| <a name="input_private_subnets_cidrs"></a> [private\_subnets\_cidrs](#input\_private\_subnets\_cidrs) | list of strings: declare cidrs for the private subnets | `list(string)` | `[]` | no |
| <a name="input_public_subnet_assign_ipv6_address_on_creation"></a> [public\_subnet\_assign\_ipv6\_address\_on\_creation](#input\_public\_subnet\_assign\_ipv6\_address\_on\_creation) | Specify true to indicate that network interfaces created in the specified subnet should be assigned an IPv6 address. | `bool` | `true` | no |
| <a name="input_public_subnet_enable_dns64"></a> [public\_subnet\_enable\_dns64](#input\_public\_subnet\_enable\_dns64) | Indicates whether DNS queries made to the Amazon-provided DNS Resolver in this subnet should return synthetic IPv6 addresses for IPv4-only destinations. | `bool` | `true` | no |
| <a name="input_public_subnet_enable_resource_name_dns_a_record_on_launch"></a> [public\_subnet\_enable\_resource\_name\_dns\_a\_record\_on\_launch](#input\_public\_subnet\_enable\_resource\_name\_dns\_a\_record\_on\_launch) | Indicates whether to respond to DNS queries for instance hostnames with DNS A records | `bool` | `false` | no |
| <a name="input_public_subnet_enable_resource_name_dns_aaaa_record_on_launch"></a> [public\_subnet\_enable\_resource\_name\_dns\_aaaa\_record\_on\_launch](#input\_public\_subnet\_enable\_resource\_name\_dns\_aaaa\_record\_on\_launch) | Indicates whether to respond to DNS queries for instance hostnames with DNS AAAA records. | `bool` | `false` | no |
| <a name="input_public_subnets_cidrs"></a> [public\_subnets\_cidrs](#input\_public\_subnets\_cidrs) | list of strings: declare cidrs for the public subnets | `list(string)` | `[]` | no |
| <a name="input_regex_replace_chars"></a> [regex\_replace\_chars](#input\_regex\_replace\_chars) | Terraform regular expression (regex) string.<br>Characters matching the regex will be removed from the ID elements.<br>If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits. | `string` | `null` | no |
| <a name="input_region_config"></a> [region\_config](#input\_region\_config) | full region config | <pre>object({<br>    enabled = bool<br>    short   = string<br>    az_ids  = list(string)<br>  })</pre> | n/a | yes |
| <a name="input_stage"></a> [stage](#input\_stage) | ID element. Usually used to indicate role, e.g. 'prod', 'staging', 'source', 'build', 'test', 'deploy', 'release' | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags (e.g. `{'BusinessUnit': 'XYZ'}`).<br>Neither the tag keys nor the tag values will be modified by this module. | `map(string)` | `{}` | no |
| <a name="input_tenant"></a> [tenant](#input\_tenant) | ID element \_(Rarely used, not included by default)\_. A customer identifier, indicating who this instance of a resource is for | `string` | `null` | no |
| <a name="input_tgw_id"></a> [tgw\_id](#input\_tgw\_id) | TGW ID | `string` | `null` | no |
| <a name="input_tgw_static_routes"></a> [tgw\_static\_routes](#input\_tgw\_static\_routes) | Static Routes to send via the Transit Gateway from the VPC | `list(string)` | <pre>[<br>  "10.0.0.0/8"<br>]</pre> | no |
| <a name="input_tgw_subnet_assign_ipv6_address_on_creation"></a> [tgw\_subnet\_assign\_ipv6\_address\_on\_creation](#input\_tgw\_subnet\_assign\_ipv6\_address\_on\_creation) | Specify true to indicate that network interfaces created in the specified subnet should be assigned an IPv6 address. | `bool` | `true` | no |
| <a name="input_tgw_subnet_enable_dns64"></a> [tgw\_subnet\_enable\_dns64](#input\_tgw\_subnet\_enable\_dns64) | Indicates whether DNS queries made to the Amazon-provided DNS Resolver in this subnet should return synthetic IPv6 addresses for IPv4-only destinations. | `bool` | `true` | no |
| <a name="input_tgw_subnet_enable_resource_name_dns_a_record_on_launch"></a> [tgw\_subnet\_enable\_resource\_name\_dns\_a\_record\_on\_launch](#input\_tgw\_subnet\_enable\_resource\_name\_dns\_a\_record\_on\_launch) | Indicates whether to respond to DNS queries for instance hostnames with DNS A records | `bool` | `false` | no |
| <a name="input_tgw_subnet_enable_resource_name_dns_aaaa_record_on_launch"></a> [tgw\_subnet\_enable\_resource\_name\_dns\_aaaa\_record\_on\_launch](#input\_tgw\_subnet\_enable\_resource\_name\_dns\_aaaa\_record\_on\_launch) | Indicates whether to respond to DNS queries for instance hostnames with DNS AAAA records. | `bool` | `false` | no |
| <a name="input_tgw_subnets_cidrs"></a> [tgw\_subnets\_cidrs](#input\_tgw\_subnets\_cidrs) | list of strings: declare cidrs for the transit gateway subnets | `list(string)` | `[]` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | string: cidr for the vpc | `string` | `null` | no |
| <a name="input_vpc_flow_log_iam_policy_name"></a> [vpc\_flow\_log\_iam\_policy\_name](#input\_vpc\_flow\_log\_iam\_policy\_name) | Name of the IAM policy | `string` | `"vpc-flow-log-to-cloudwatch"` | no |
| <a name="input_vpc_flow_log_iam_policy_use_name_prefix"></a> [vpc\_flow\_log\_iam\_policy\_use\_name\_prefix](#input\_vpc\_flow\_log\_iam\_policy\_use\_name\_prefix) | Determines whether the name of the IAM policy (`vpc_flow_log_iam_policy_name`) is used as a prefix | `bool` | `true` | no |
| <a name="input_vpc_flow_log_iam_role_name"></a> [vpc\_flow\_log\_iam\_role\_name](#input\_vpc\_flow\_log\_iam\_role\_name) | Name to use on the VPC Flow Log IAM role created | `string` | `"vpc-flow-log-role"` | no |
| <a name="input_vpc_flow_log_iam_role_use_name_prefix"></a> [vpc\_flow\_log\_iam\_role\_use\_name\_prefix](#input\_vpc\_flow\_log\_iam\_role\_use\_name\_prefix) | Determines whether the IAM role name (`vpc_flow_log_iam_role_name_name`) is used as a prefix | `bool` | `true` | no |
| <a name="input_vpc_flow_log_permissions_boundary"></a> [vpc\_flow\_log\_permissions\_boundary](#input\_vpc\_flow\_log\_permissions\_boundary) | The ARN of the Permissions Boundary for the VPC Flow Log IAM Role | `string` | `null` | no |
| <a name="input_vpc_flow_log_tags"></a> [vpc\_flow\_log\_tags](#input\_vpc\_flow\_log\_tags) | Additional tags for the VPC Flow Logs | `map(string)` | `{}` | no |
| <a name="input_vpc_peers"></a> [vpc\_peers](#input\_vpc\_peers) | List of maps defining the VPCs to peer with | <pre>list(map(object({<br>    vpc_id       = string<br>    account_id   = string<br>    region       = string<br>    cidr         = string<br>    route_tables = list(string)<br>  })))</pre> | `[]` | no |
| <a name="input_vpc_tags"></a> [vpc\_tags](#input\_vpc\_tags) | Additional tags for the VPC | `map(string)` | `{}` | no |

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
<!-- END_TF_DOCS -->

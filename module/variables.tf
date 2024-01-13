#######################################################################
# CloudPosse variables
#######################################################################
# these are needed since we are calling a submodule

variable "classifier" {
  description = "Declare the environment [p: prod, d: dev, & s: staging]"
  type        = string
}

variable "namespace" {
  type        = string
  default     = null
  description = "ID element. Usually an abbreviation of your organization name, e.g. 'eg' or 'cp', to help ensure generated IDs are    globally unique"
}

variable "environment" {
  type        = string
  default     = null
  description = "ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT'"
}

variable "stage" {
  type        = string
  default     = null
  description = "ID element. Usually used to indicate role, e.g. 'prod', 'staging', 'source', 'build', 'test', 'deploy', 'release'"
}

variable "name" {
  type        = string
  description = <<-EOT
  ID element. Usually the component or solution name, e.g. 'app' or 'jenkins'.
  This is the only ID element not also included as a `tag`.
  The "name" tag is set to the full `id` string. There is no tag with the value of the `name` input.
  EOT
}

variable "tenant" {
  type        = string
  default     = null
  description = "ID element _(Rarely used, not included by default)_. A customer identifier, indicating who this instance of a         resource is for"
}

variable "label_order" {
  type        = list(string)
  default     = null
  description = <<-EOT
    The order in which the labels (ID elements) appear in the `id`.
    Defaults to ["namespace", "environment", "stage", "name", "attributes"].
    You can omit any of the 6 labels ("tenant" is the 6th), but at least one must be present.
    EOT
}

# VPC
variable "vpc_cidr" {
  description = "string: cidr for the vpc"
  type        = string
}

variable "region_config" {
  description = "full region config"
  type = object({
    enabled = bool
    short   = string
    az_ids  = list(string)
  })
}

# SUBNETS
variable "public_subnets_cidrs" {
  description = "list of strings: declare cidrs for the public subnets"
  type        = list(string)
  default     = []
}

variable "private_subnets_cidrs" {
  description = "list of strings: declare cidrs for the private subnets"
  type        = list(string)
  default     = []
}

variable "firewall_subnets_cidrs" {
  description = "list of strings: declare cidrs for the firewall subnets"
  type        = list(string)
  default     = []
}


variable "availability_zone_ids" {
  description = "List of AZ IDs for VPC subnets"
  type        = list(string)
}

variable "enable_ipam" {
  description = "Whether to enable the AWS VPC IPAM or not in CIDR selection (Default: false)"
  type        = bool
  default     = false
}

variable "ipam_pool" {
  description = "AWS IPAM Pool Name"
  type        = string
  default     = null
}

variable "cidr_mask_length" {
  description = "Mask length to yank from IPAM pool"
  type        = number
  default     = 21
}

# VPC PEERS
variable "vpc_peers" {
  description = "List of maps defining the VPCs to peer with"
  type = list(map(object({
    vpc_id       = string
    account_id   = string
    region       = string
    cidr         = string
    route_tables = list(string)
  })))
  default = []
}

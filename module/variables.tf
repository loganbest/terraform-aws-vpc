variable "classifier" {
  description = "Declare the environment [p: prod, d: dev, & s: staging]"
  type        = string
}

variable "name" {
  description = "Name of the environment"
  type        = string
}

# VPC
variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "string: cidr for the vpc"
  type        = string
}

variable "region_config" {
  description = "full region config"
  type = object({
    enabled  = bool
    short    = string
    az_ids   = list(string)
    registry = string
  })
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

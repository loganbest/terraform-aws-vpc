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

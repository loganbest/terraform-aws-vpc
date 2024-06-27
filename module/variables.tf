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

variable "default_security_group_ingress" {
  description = "Ingress rules for the VPC Default Security Group. By default set for allow nothing"
  type = list(map(string))
  default = []
}

variable "default_security_group_egress" {
  description = "Egress rules for the VPC Default Security Group. By default set for allow nothing"
  type = list(map(string))
  default = []
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

variable "enable_anf" {
  description = "Whether to enable the components needed for using AWS Network Firewall (Default: false)"
  type        = bool
  default     = false
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

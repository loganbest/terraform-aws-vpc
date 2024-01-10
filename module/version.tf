terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = "~> 5.8"
      configuration_aliases = [aws.net_prod, aws.net_prod_use1, aws.net_prod_use2]
    }
    external = {
      source  = "hashicorp/external"
      version = "~> 2.0"
    }
  }
}

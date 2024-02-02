terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = ">= 5.21"
      configuration_aliases = [aws.eu_west_2]
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 2.0"
    }
  }
}

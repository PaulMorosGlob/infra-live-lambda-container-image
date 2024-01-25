terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.22"
    }
    null = {
      version = "~> 3.0.0"
    }
  }

  required_version = ">= 1.1.7"

  backend "s3" {
  }
}

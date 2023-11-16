terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.22"
    }
  }

  required_version = ">= 1.1.7"

}

module "iam" {
  source = "../../modules/iam"

  ecr_repository_name = module.ecr.ecr_repository_name
}


module "ecr" {
  source = "../../modules/ecr"

  region      = "us-east-1"
  app_name    = "my_example_app"
  environment = "example"
  tags = {
    "Terraform" = "true"
    "Env"       = "example"
  }
}

provider "aws" {
  region = var.region
}

resource "aws_ecr_repository" "ecr_repo" {
  name = "${var.app_name}_${var.environment}_ecr_repo"
  tags = var.tags
}
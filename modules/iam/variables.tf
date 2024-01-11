variable "region" {
  type    = string
  default = "us-east-1"
}

variable "ecr_arn" {
    type    = string    
}

variable "ecr_repository_name" {
    type    = string    
}

variable "environment" {
  type    = string
  default = "sandbox"
}

variable "app_name" {
  type    = string
  default = "myapp"
}

variable "tags" {
  type = map(string)
  default = {
    "Environment" = "sandbox"
    "Application" = "myapp"
  }
}
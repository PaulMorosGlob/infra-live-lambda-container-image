region         = "us-east-1"
bucket         = "glob-sandbox-terraform-states"
key            = "lambda-container/develop/terraform.tfstate"
dynamodb_table = "glob-terraform-states-lock"
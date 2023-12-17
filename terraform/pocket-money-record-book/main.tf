terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.14.0"
    }
  }
  required_version = ">= 1.4.2"
}

provider "aws" {
  region                   = "ap-northeast-1"
  shared_credentials_files = ["~/.aws/credentials"]
}

# import {
#   id = "XXXXXX"
#   to = aws_cognito_user_pool.user-pool
# }

# resource "aws_cognito_user_pool" "user-pool" {
#   name = "pocket-money-record-book-dev-user-pool"
#   auto_verified_attributes = [
#     "email",
#   ]
#   deletion_protection = "ACTIVE"
# }

// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table
resource "aws_dynamodb_table" "main" {
  name           = "pocket-money-record-book-dev-user-table"
  hash_key       = "id"
  attribute {
    name = "id"
    type = "S"
  }
}

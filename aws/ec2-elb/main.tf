terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.60"
    }
  }
  required_version = ">= 1.4.2"
}

provider "aws" {
  region                   = "ap-northeast-1"
  shared_credentials_files = ["~/.aws/credentials"]
}

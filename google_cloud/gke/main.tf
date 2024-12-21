terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 6.11.1"
    }
  }
  required_version = ">= 1.4.2"
}

provider "google" {
  project = var.project_name
  region  = "us-central1"
}


module "vpc" {
  source = "./modules/vpc"
}

module "gke" {
  source      = "./modules/gke"
  vpc_name    = module.vpc.vpc_name
  subnet_name = module.vpc.subnet_name
}

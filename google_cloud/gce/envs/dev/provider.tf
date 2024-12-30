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
  project = locals.project_name
  region  = "us-central1"
}

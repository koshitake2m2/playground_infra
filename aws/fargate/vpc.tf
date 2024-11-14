locals {
  # subnet: "10.10.1.0/24"
  # subnet: "10.10.2.0/24"
  vpc_a_cidr_block = "10.10.0.0/16"
}

module "vpc_a" {
  source         = "./modules/vpc"
  vpc_name       = "vpc_a"
  vpc_cidr_block = local.vpc_a_cidr_block
}

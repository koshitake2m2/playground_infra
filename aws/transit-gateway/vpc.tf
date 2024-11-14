locals {
  # subnet: "10.10.1.0/24"
  # subnet: "10.10.2.0/24"
  vpc_a_cidr_block = "10.10.0.0/16"

  # subnet: "10.20.1.0/24"
  # subnet: "10.20.2.0/24"
  vpc_b_cidr_block = "10.20.0.0/16"
}

module "vpc_a" {
  source               = "./modules/vpc"
  vpc_name             = "vpc_a"
  vpc_cidr_block       = local.vpc_a_cidr_block
  other_vpc_cidr_block = local.vpc_b_cidr_block
  transit_gateway_id   = aws_ec2_transit_gateway.tgw_t.id
}

module "vpc_b" {
  source               = "./modules/vpc"
  vpc_name             = "vpc_b"
  vpc_cidr_block       = local.vpc_b_cidr_block
  other_vpc_cidr_block = local.vpc_a_cidr_block
  transit_gateway_id   = aws_ec2_transit_gateway.tgw_t.id
}

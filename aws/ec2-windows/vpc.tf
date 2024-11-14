module "vpc_windows" {
  source         = "./modules/vpc"
  vpc_name       = "vpc_windows"
  vpc_cidr_block = "10.10.0.0/16"
}

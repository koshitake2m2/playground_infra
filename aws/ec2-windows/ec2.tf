module "ec2_key_pair" {
  source = "./modules/ec2-key-pair"
}

module "app_server_a" {
  source    = "./modules/ec2"
  vpc_id    = module.vpc_windows.vpc_id
  vpc_name  = "vpc_windows"
  subnet_id = module.vpc_windows.public_ec2_subnet_id
  key_name  = module.ec2_key_pair.key_name
}

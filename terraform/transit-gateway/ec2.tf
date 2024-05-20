module "ec2_key_pair" {
  source = "./modules/ec2-key-pair"
}

module "app_server_a" {
  source    = "./modules/ec2"
  vpc_id    = aws_vpc.vpc_a.id
  subnet_id = aws_subnet.a_public_ec2.id
  key_name  = module.ec2_key_pair.key_name
}

module "app_server_b" {
  source    = "./modules/ec2"
  vpc_id    = aws_vpc.vpc_b.id
  subnet_id = aws_subnet.b_public_ec2.id
  key_name  = module.ec2_key_pair.key_name
}

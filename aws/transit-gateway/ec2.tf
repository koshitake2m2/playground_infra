module "ec2_key_pair" {
  source = "./modules/ec2-key-pair"
}

module "app_server_a" {
  source    = "./modules/ec2"
  vpc_id    = module.vpc_a.vpc_id
  vpc_name  = "vpc_a"
  subnet_id = module.vpc_a.public_ec2_subnet_id
  key_name  = module.ec2_key_pair.key_name
}

module "app_server_b" {
  source    = "./modules/ec2"
  vpc_id    = module.vpc_b.vpc_id
  vpc_name  = "vpc_b"
  subnet_id = module.vpc_b.public_ec2_subnet_id
  key_name  = module.ec2_key_pair.key_name
}

// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip
resource "aws_eip" "app_server_a_ip" {
  vpc      = true
  instance = module.app_server_a.instance_id

  tags = {
    Name = "app_server_a_ip"
  }
}

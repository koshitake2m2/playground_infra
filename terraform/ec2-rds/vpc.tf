
// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "main_vpc"
  }
}

resource "aws_eip" "api_server_ip" {
  vpc      = true
  instance = aws_instance.app_server.id

  tags = {
    Name = "app_server_ip"
  }
}


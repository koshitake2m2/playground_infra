
// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "main_vpc"
  }
}

// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet
resource "aws_subnet" "public_1a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.0.0/20"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "public_1a"
  }
}

resource "aws_subnet" "public_1c" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.16.0/20"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = true
  tags = {
    Name = "public_1c"
  }
}

// 特別な事情がない限り, default_network_aclは触らないほうがいい
// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_network_acl
# resource "aws_default_network_acl" "default" {
#   default_network_acl_id = aws_vpc.main.default_network_acl_id
#   ingress {
#     protocol   = -1
#     rule_no    = 100
#     action     = "allow"
#     cidr_block = "0.0.0.0/0"
#     from_port  = 0
#     to_port    = 0
#   }
#   egress {
#     protocol   = -1
#     rule_no    = 100
#     action     = "allow"
#     cidr_block = "0.0.0.0/0"
#     from_port  = 0
#     to_port    = 0
#   }
#   subnet_ids = [
#     aws_subnet.public_1a.id,
#     aws_subnet.public_1c.id,
#   ]
# }

# vpc内と外をアクセス可能にする
// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main_gateway"
  }
}

// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip
resource "aws_eip" "api_server_1a_ip" {
  vpc      = true
  instance = aws_instance.app_server_1a.id

  tags = {
    Name = "app_server_1a_ip"
  }
}

resource "aws_eip" "api_server_1c_ip" {
  vpc      = true
  instance = aws_instance.app_server_1c.id

  tags = {
    Name = "app_server_1c_ip"
  }
}


// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = {
    Name = "route_table_public"
  }
}

// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association
resource "aws_route_table_association" "public_1a" {
  subnet_id      = aws_subnet.public_1a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_1c" {
  subnet_id      = aws_subnet.public_1c.id
  route_table_id = aws_route_table.public.id
}

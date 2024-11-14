
variable "vpc_name" {
  type = string
}

variable "vpc_cidr_block" {
  type = string
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_ec2_subnet_id" {
  value = aws_subnet.public_ec2.id
}

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.vpc_name}"
  }
}

resource "aws_subnet" "public_ec2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(var.vpc_cidr_block, 8, 1)
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.vpc_name}__public_ec2"
  }
}

// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway
resource "aws_internet_gateway" "vpc_igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.vpc_name}__igw"
  }
}

// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
resource "aws_route_table" "vpc" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc_igw.id
  }
  tags = {
    Name = "${var.vpc_name}__route_table"
  }
}

// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association
resource "aws_route_table_association" "vpc_public_ec2" {
  subnet_id      = aws_subnet.public_ec2.id
  route_table_id = aws_route_table.vpc.id
}

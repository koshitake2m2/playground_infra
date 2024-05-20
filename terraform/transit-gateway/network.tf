
/////////////////
// vpc a
/////////////////
resource "aws_vpc" "vpc_a" {
  cidr_block           = "10.10.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "vpc_a"
  }
}

resource "aws_subnet" "a_public_ec2" {
  vpc_id                  = aws_vpc.vpc_a.id
  cidr_block              = "10.10.1.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "a_public_ec2"
  }
}

resource "aws_subnet" "a_private_tgw_attachment" {
  vpc_id                  = aws_vpc.vpc_a.id
  cidr_block              = "10.10.2.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "a_private_tgw_attachment"
  }
}
# vpc内と外をアクセス可能にする
// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway
resource "aws_internet_gateway" "vpc_a_igw" {
  vpc_id = aws_vpc.vpc_a.id
  tags = {
    Name = "vpc_a_igw"
  }
}
// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip
resource "aws_eip" "app_server_a_ip" {
  vpc      = true
  instance = module.app_server_a.instance_id

  tags = {
    Name = "app_server_a_ip"
  }
}

// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
resource "aws_route_table" "vpc_a" {
  vpc_id = aws_vpc.vpc_a.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc_a_igw.id
  }
  route {
    cidr_block         = "10.20.0.0/16"
    transit_gateway_id = aws_ec2_transit_gateway.tgw_t.id
  }
  tags = {
    Name = "vpc_a"
  }
}

// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association
resource "aws_route_table_association" "vpc_a_public_ec2" {
  subnet_id      = aws_subnet.a_public_ec2.id
  route_table_id = aws_route_table.vpc_a.id
}

resource "aws_route_table_association" "vpc_a_private_tgw_attachment" {
  subnet_id      = aws_subnet.a_private_tgw_attachment.id
  route_table_id = aws_route_table.vpc_a.id
}



/////////////////
// vpc b
/////////////////

resource "aws_vpc" "vpc_b" {
  cidr_block           = "10.20.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "vpc_b"
  }
}

resource "aws_subnet" "b_public_ec2" {
  vpc_id                  = aws_vpc.vpc_b.id
  cidr_block              = "10.20.1.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "b_public_ec2"
  }
}

resource "aws_subnet" "b_private_tgw_attachment" {
  vpc_id                  = aws_vpc.vpc_b.id
  cidr_block              = "10.20.2.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "b_private_tgw_attachment"
  }
}


resource "aws_internet_gateway" "vpc_b_igw" {
  vpc_id = aws_vpc.vpc_b.id
  tags = {
    Name = "vpc_b_igw"
  }
}

resource "aws_route_table" "vpc_b" {
  vpc_id = aws_vpc.vpc_b.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc_b_igw.id
  }
  route {
    cidr_block         = "10.10.0.0/16"
    transit_gateway_id = aws_ec2_transit_gateway.tgw_t.id
  }
  tags = {
    Name = "vpc_b"
  }
}

resource "aws_route_table_association" "vpc_b_public_ec2" {
  subnet_id      = aws_subnet.b_public_ec2.id
  route_table_id = aws_route_table.vpc_b.id
}

resource "aws_route_table_association" "vpc_b_private_tgw_attachment" {
  subnet_id      = aws_subnet.b_private_tgw_attachment.id
  route_table_id = aws_route_table.vpc_b.id
}

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

# vpc内と外をアクセス可能にする
// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main_gateway"
  }
}

// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip
resource "aws_eip" "public_1a" {
  vpc = true

  tags = {
    Name = "public_1a"
  }
}

# vpc内からインターネットに接続可能にする
// https://docs.aws.amazon.com/ja_jp/vpc/latest/userguide/vpc-nat-gateway.html
// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway
resource "aws_nat_gateway" "public_1a" {
  allocation_id = aws_eip.public_1a.id
  subnet_id     = aws_subnet.public_1a.id

  tags = {
    Name = "public_1a"
  }
}

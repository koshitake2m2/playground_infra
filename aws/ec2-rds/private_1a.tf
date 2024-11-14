
resource "aws_subnet" "private_1a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.128.0/20"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = false
  tags = {
    Name = "private_1a"
  }
}


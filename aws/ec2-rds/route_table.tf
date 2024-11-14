// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
resource "aws_route_table" "public_1a" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = {
    Name = "route_table public_1a"
  }
}

// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association
resource "aws_route_table_association" "public_1a" {
  subnet_id      = aws_subnet.public_1a.id
  route_table_id = aws_route_table.public_1a.id
}

resource "aws_route_table" "private_1a" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.public_1a.id
  }
  tags = {
    Name = "route_table private_1a"
  }
  lifecycle {
    // https://developer.hashicorp.com/terraform/tutorials/state/resource-lifecycle#create-resources-before-they-are-destroyed
    create_before_destroy = true
  }
}

resource "aws_route_table_association" "private_1a" {
  subnet_id      = aws_subnet.private_1a.id
  route_table_id = aws_route_table.private_1a.id
}


resource "aws_route_table" "private_1c" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.public_1a.id
  }
  tags = {
    Name = "route_table private_1c"
  }
  lifecycle {
    // https://developer.hashicorp.com/terraform/tutorials/state/resource-lifecycle#create-resources-before-they-are-destroyed
    create_before_destroy = true
  }
}

resource "aws_route_table_association" "private_1c" {
  subnet_id      = aws_subnet.private_1c.id
  route_table_id = aws_route_table.private_1c.id
}

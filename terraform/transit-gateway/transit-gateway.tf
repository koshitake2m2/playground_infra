// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway
resource "aws_ec2_transit_gateway" "tgw_t" {
  tags = {
    Name = "tgw_t"
  }
}

// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_vpc_attachment
resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_attachment_a" {
  subnet_ids         = [aws_subnet.a_private_tgw_attachment.id]
  transit_gateway_id = aws_ec2_transit_gateway.tgw_t.id
  vpc_id             = aws_vpc.vpc_a.id
  tags = {
    Name = "tgw_attachment_a"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_attachment_b" {
  subnet_ids         = [aws_subnet.b_private_tgw_attachment.id]
  transit_gateway_id = aws_ec2_transit_gateway.tgw_t.id
  vpc_id             = aws_vpc.vpc_b.id
  tags = {
    Name = "tgw_attachment_b"
  }
}

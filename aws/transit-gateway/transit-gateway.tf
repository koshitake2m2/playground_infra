// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway
resource "aws_ec2_transit_gateway" "tgw_t" {
  tags = {
    Name = "tgw_t"
  }
}

// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_vpc_attachment
resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_attachment_a" {
  subnet_ids         = [module.vpc_a.private_tgw_attachment_subnet_id]
  transit_gateway_id = aws_ec2_transit_gateway.tgw_t.id
  vpc_id             = module.vpc_a.vpc_id
  tags = {
    Name = "tgw_attachment_a"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_attachment_b" {
  subnet_ids         = [module.vpc_b.private_tgw_attachment_subnet_id]
  transit_gateway_id = aws_ec2_transit_gateway.tgw_t.id
  vpc_id             = module.vpc_b.vpc_id
  tags = {
    Name = "tgw_attachment_b"
  }
}

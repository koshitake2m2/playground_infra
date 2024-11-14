variable "vpc_id" {
  type = string
}

// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
resource "aws_security_group" "app_server_sg" {
  name   = "app_server_sg"
  vpc_id = var.vpc_id

  tags = {
    Name = "app_server_sg__${var.vpc_id}"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_rdp" {
  security_group_id = aws_security_group.app_server_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 3389
  to_port           = 3389
  tags = {
    Name = "allow_rdp"
  }
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic" {
  security_group_id = aws_security_group.app_server_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
  tags = {
    Name = "allow_all_traffic"
  }
}


// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
resource "aws_security_group" "ecs_service_sg" {
  name   = "ecs_service_sg"
  vpc_id = module.vpc_a.vpc_id

  tags = {
    Name = "ecs_service_sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ecs_service_sg__allow_http" {
  security_group_id = aws_security_group.ecs_service_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 8080
  to_port           = 8080
  tags = {
    Name = "ecs_service_sg__allow_http"
  }
}

resource "aws_vpc_security_group_egress_rule" "ecs_service_sg__allow_all_traffic" {
  security_group_id = aws_security_group.ecs_service_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
  tags = {
    Name = "ecs_service_sg__allow_all_traffic"
  }
}


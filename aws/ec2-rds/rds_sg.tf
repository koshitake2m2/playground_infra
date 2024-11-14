// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
resource "aws_security_group" "rds_sg" {
  name   = "rds_sg"
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "rds_sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_postgres" {
  security_group_id = aws_security_group.rds_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 5432
  to_port           = 5432
  tags = {
    Name = "allow_postgres"
  }
}

// NOTE: http, https, postgresだけにするのが良いがライトウェイトにするために全てのトラフィックを許可している
resource "aws_vpc_security_group_egress_rule" "allow_db_all_traffic" {
  security_group_id = aws_security_group.rds_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
  tags = {
    Name = "allow_db_all_traffic"
  }
}


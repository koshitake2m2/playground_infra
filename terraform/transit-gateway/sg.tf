# # TODO: 冗長なのでmodule化する

# /////////////////
# // app_server_a
# /////////////////

# // https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
# resource "aws_security_group" "app_server_a_sg" {
#   name   = "app_server_a_sg"
#   vpc_id = aws_vpc.vpc_a.id

#   tags = {
#     Name = "app_server_a_sg"
#   }
# }

# resource "aws_vpc_security_group_ingress_rule" "allow_http" {
#   security_group_id = aws_security_group.app_server_a_sg.id
#   cidr_ipv4         = "0.0.0.0/0"
#   ip_protocol       = "tcp"
#   from_port         = 80
#   to_port           = 80
#   tags = {
#     Name = "allow_http"
#   }
# }

# resource "aws_vpc_security_group_ingress_rule" "allow_https" {
#   security_group_id = aws_security_group.app_server_a_sg.id
#   cidr_ipv4         = "0.0.0.0/0"
#   ip_protocol       = "tcp"
#   from_port         = 443
#   to_port           = 443
#   tags = {
#     Name = "allow_https"
#   }
# }

# resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
#   security_group_id = aws_security_group.app_server_a_sg.id
#   cidr_ipv4         = "0.0.0.0/0"
#   ip_protocol       = "tcp"
#   from_port         = 22
#   to_port           = 22
#   tags = {
#     Name = "allow_ssh"
#   }
# }

# resource "aws_vpc_security_group_egress_rule" "allow_all_traffic" {
#   security_group_id = aws_security_group.app_server_a_sg.id
#   cidr_ipv4         = "0.0.0.0/0"
#   ip_protocol       = "-1" # semantically equivalent to all ports
#   tags = {
#     Name = "allow_all_traffic"
#   }
# }

# /////////////////
# // app_server_b
# /////////////////

# resource "aws_security_group" "app_server_b_sg" {
#   name   = "app_server_b_sg"
#   vpc_id = aws_vpc.vpc_b.id

#   tags = {
#     Name = "app_server_b_sg"
#   }
# }

# resource "aws_vpc_security_group_ingress_rule" "allow_http_b" {
#   security_group_id = aws_security_group.app_server_b_sg.id
#   cidr_ipv4         = "0.0.0.0/0"
#   ip_protocol       = "tcp"
#   from_port         = 80
#   to_port           = 80
#   tags = {
#     Name = "allow_http_b"
#   }
# }

# resource "aws_vpc_security_group_ingress_rule" "allow_https_b" {
#   security_group_id = aws_security_group.app_server_b_sg.id
#   cidr_ipv4         = "0.0.0.0/0"
#   ip_protocol       = "tcp"
#   from_port         = 443
#   to_port           = 443
#   tags = {
#     Name = "allow_https_b"
#   }
# }

# resource "aws_vpc_security_group_ingress_rule" "allow_ssh_b" {
#   security_group_id = aws_security_group.app_server_b_sg.id
#   cidr_ipv4         = "0.0.0.0/0"
#   ip_protocol       = "tcp"
#   from_port         = 22
#   to_port           = 22
#   tags = {
#     Name = "allow_ssh_b"
#   }
# }

# resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_b" {
#   security_group_id = aws_security_group.app_server_b_sg.id
#   cidr_ipv4         = "0.0.0.0/0"
#   ip_protocol       = "-1" # semantically equivalent to all ports
#   tags = {
#     Name = "allow_all_traffic_b"
#   }
# }


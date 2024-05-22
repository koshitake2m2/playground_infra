variable "vpc_name" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "key_name" {
  type = string
}

output "instance_id" {
  value = aws_instance.app_server.id
}

resource "aws_instance" "app_server" {
  # Microsoft Windows Server 2022 Base
  ami      = "ami-01a8ef944f58a13cd"
  key_name = var.key_name
  # t2.microは無料利用枠
  # instance_type          = "t2.micro" # MEM: 1GB, CPU: 1
  instance_type          = "t2.medium" # MEM: 4GB, CPU: 2
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.app_server_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.session_manager.name

  tags = {
    Name = "${var.vpc_name}__app_server"
  }
}

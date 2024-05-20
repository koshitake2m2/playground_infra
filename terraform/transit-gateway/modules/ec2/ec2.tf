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
  ami                    = "ami-0b828c1c5ac3f13ee"
  key_name               = var.key_name
  instance_type          = "t2.micro"
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.app_server_sg.id]
  user_data              = file("modules/ec2/setup.sh")

  tags = {
    Name = "${var.vpc_name}__app_server"
  }
}

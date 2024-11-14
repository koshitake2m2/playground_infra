resource "aws_instance" "app_server" {
  ami             = "ami-0b828c1c5ac3f13ee"
  key_name        = aws_key_pair.ssh_pub_key.key_name
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.public_1a.id
  security_groups = [aws_security_group.app_server_sg.id]

  tags = {
    Name = "app_server"
  }
}

resource "aws_key_pair" "ssh_pub_key" {
  key_name   = "app_server_key"
  public_key = file("./ssh_keys/ssh_key.pub")
}

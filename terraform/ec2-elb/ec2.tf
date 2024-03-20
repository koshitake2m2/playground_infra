
resource "aws_instance" "app_server_1a" {
  ami                    = "ami-0b828c1c5ac3f13ee"
  key_name               = aws_key_pair.ssh_pub_key.key_name
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_1a.id
  vpc_security_group_ids = [aws_security_group.app_server_sg.id]
  user_data              = file("./setup_1a.sh")

  tags = {
    Name = "app_server_1a"
  }
}

resource "aws_instance" "app_server_1c" {
  ami                    = "ami-0b828c1c5ac3f13ee"
  key_name               = aws_key_pair.ssh_pub_key.key_name
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_1c.id
  vpc_security_group_ids = [aws_security_group.app_server_sg.id]
  user_data              = file("./setup_1c.sh")

  tags = {
    Name = "app_server_1c"
  }
}

resource "aws_key_pair" "ssh_pub_key" {
  key_name   = "app_server_key"
  public_key = file("./ssh_keys/ssh_key.pub")
}

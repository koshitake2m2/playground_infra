
resource "aws_instance" "app_server_a" {
  ami                    = "ami-0b828c1c5ac3f13ee"
  key_name               = aws_key_pair.ssh_pub_key.key_name
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.a_public_ec2.id
  vpc_security_group_ids = [aws_security_group.app_server_a_sg.id]
  user_data              = file("./setup.sh")

  tags = {
    Name = "app_server_a"
  }
}

resource "aws_instance" "app_server_b" {
  ami                    = "ami-0b828c1c5ac3f13ee"
  key_name               = aws_key_pair.ssh_pub_key.key_name
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.b_public_ec2.id
  vpc_security_group_ids = [aws_security_group.app_server_b_sg.id]
  user_data              = file("./setup.sh")

  tags = {
    Name = "app_server_b"
  }
}

resource "aws_key_pair" "ssh_pub_key" {
  key_name   = "app_server_key"
  public_key = file("./ssh_keys/ssh_key.pub")
}

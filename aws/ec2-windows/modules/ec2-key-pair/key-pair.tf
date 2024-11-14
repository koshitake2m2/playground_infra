output "key_name" {
  value = aws_key_pair.ssh_pub_key.key_name
}

resource "aws_key_pair" "ssh_pub_key" {
  key_name   = "app_server_key"
  public_key = file("ssh_keys/ssh_key.pub")
}

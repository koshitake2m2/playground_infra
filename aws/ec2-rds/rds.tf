// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance
resource "aws_db_instance" "mydb" {
  allocated_storage      = 20
  db_name                = "mydb"
  engine                 = "postgres"
  engine_version         = "12.18"
  instance_class         = "db.t2.micro"
  storage_type           = "gp2"
  username               = var.db_username
  password               = var.db_password
  skip_final_snapshot    = true
  multi_az               = false
  db_subnet_group_name   = aws_db_subnet_group.default.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  tags = {
    Name = "mydb"
  }
}

// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group
// - DBサブネットグループには2つ以上のAZ が必要
//   - ref: https://docs.aws.amazon.com/ja_jp/AmazonRDS/latest/UserGuide/USER_VPC.WorkingWithRDSInstanceinaVPC.html#USER_VPC.Subnets
resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = [aws_subnet.private_1a.id, aws_subnet.private_1c.id]

  tags = {
    Name = "My DB subnet group"
  }
}

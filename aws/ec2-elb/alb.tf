// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb
resource "aws_lb" "alb" {
  name               = "alb"
  internal           = false
  load_balancer_type = "application"
  # TODO: alb用にsgを用意してください
  security_groups = [aws_security_group.app_server_sg.id]
  subnets         = [aws_subnet.public_1a.id, aws_subnet.public_1c.id]
  ip_address_type = "ipv4"

  access_logs {
    enabled = true
    bucket  = aws_s3_bucket.alb_access_log.bucket
  }

  tags = {
    Name = "alb"
  }
}

// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener
resource "aws_lb_listener" "app_server" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group.arn
  }
}

// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group
resource "aws_lb_target_group" "alb_target_group" {
  name        = "albTargetGroup"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.main.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "alb"
  }
}

// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment
resource "aws_lb_target_group_attachment" "alb_target_group_attachment_app_server_1a" {
  target_group_arn = aws_lb_target_group.alb_target_group.arn
  target_id        = aws_instance.app_server_1a.id
  port             = 80
}
resource "aws_lb_target_group_attachment" "alb_target_group_attachment_app_server_1c" {
  target_group_arn = aws_lb_target_group.alb_target_group.arn
  target_id        = aws_instance.app_server_1c.id
  port             = 80
}



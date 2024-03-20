// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb
resource "aws_lb" "nlb" {
  name               = "nlb"
  internal           = false
  load_balancer_type = "network"
  # TODO: nlb用にsgを用意してください
  # security_groups = [aws_security_group.app_server_sg.id]
  subnets         = [aws_subnet.public_1a.id, aws_subnet.public_1c.id]
  ip_address_type = "ipv4"

  tags = {
    Name = "nlb"
  }
}

// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener
resource "aws_lb_listener" "alb" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = 80
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlb_target_group.arn
  }
}

// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group
resource "aws_lb_target_group" "nlb_target_group" {
  name        = "nlbTargetGroup"
  port        = 80
  protocol    = "TCP"
  target_type = "alb"
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
    Name = "nlb"
  }
}

// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment
resource "aws_lb_target_group_attachment" "nlb_target_group_attachment_alb" {
  target_group_arn = aws_lb_target_group.nlb_target_group.arn
  target_id        = aws_lb.alb.id
  port             = 80
}



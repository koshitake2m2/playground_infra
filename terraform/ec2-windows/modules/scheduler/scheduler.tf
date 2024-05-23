variable "ec2_instance_id" {
  type = string
}

variable "ec2_instance_arn" {
  type = string
}

locals {
  ec2_stop_instances_arn = "arn:aws:scheduler:::aws-sdk:ec2:stopInstances"
}

resource "aws_iam_role" "scheduler_role" {
  name                = "scheduler-role"
  managed_policy_arns = [aws_iam_policy.scheduler_policy.arn]
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "scheduler.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_policy" "scheduler_policy" {
  name = "scheduler-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "ec2:StopInstances"
        Effect = "Allow"
        Resource = [
          var.ec2_instance_arn,
        ]
      }
    ]
  })
}

resource "aws_scheduler_schedule" "stop_scheduler" {
  name       = "stop-scheduler"
  group_name = "default"

  flexible_time_window {
    mode = "OFF"
  }

  schedule_expression_timezone = "Asia/Tokyo"
  schedule_expression          = "cron(0 0 * * ? *)" # 毎日0時に実行

  target {
    arn      = local.ec2_stop_instances_arn
    role_arn = aws_iam_role.scheduler_role.arn

    input = jsonencode({
      InstanceIds = [var.ec2_instance_id]
    })
  }
}

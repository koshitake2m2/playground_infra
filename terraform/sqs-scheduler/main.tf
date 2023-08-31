terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.14.0"
    }
  }
  required_version = ">= 1.4.2"
}

provider "aws" {
  region                   = "ap-northeast-1"
  shared_credentials_files = ["~/.aws/credentials"]
}

// ref: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue
resource "aws_sqs_queue" "my_queue" {
  name                      = "my-queue"
  delay_seconds             = 90
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role
resource "aws_iam_role" "my_scheduler_role" {
  name = "my-scheduler-role"
  inline_policy {
    name = "my-scheduler-role-policy"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = "sqs:SendMessage"
          Effect = "Allow"
          Resource = [
            aws_sqs_queue.my_queue.arn
          ]
        }
      ]
    })
  }
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

# ref: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/scheduler_schedule
resource "aws_scheduler_schedule" "my_scheduler" {
  name       = "my-schedule"
  group_name = "default"

  flexible_time_window {
    mode = "OFF"
  }

  # ref: https://docs.aws.amazon.com/scheduler/latest/UserGuide/schedule-types.html
  schedule_expression_timezone = "Asia/Tokyo"
  # schedule_expression = "rate(1 hours)"
  schedule_expression = "cron(0/5 * * * ? *)"

  target {
    # arn = "arn:aws:scheduler:::aws-sdk:sqs:sendMessage"

    arn      = aws_sqs_queue.my_queue.arn
    role_arn = aws_iam_role.my_scheduler_role.arn

    input = jsonencode({
      # MessageBody = "{ \"hello\": \"world\"}"
      MessageBody = jsonencode({
        hello = "world"
      })
      QueueUrl = aws_sqs_queue.my_queue.url
    })
  }
}

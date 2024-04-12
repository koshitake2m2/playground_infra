# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role
resource "aws_iam_role" "my_sqs_scheduler_role" {
  name = "my-sqs-scheduler-role"
  managed_policy_arns = [aws_iam_policy.my_sqs_scheduler_policy.arn]
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

resource "aws_iam_policy" "my_sqs_scheduler_policy" {
  name = "my-sqs-scheduler-policy"
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
  schedule_expression = "cron(0/6 * * * ? *)"

  target {
    # arn = "arn:aws:scheduler:::aws-sdk:sqs:sendMessage"

    arn      = aws_sqs_queue.my_queue.arn
    role_arn = aws_iam_role.my_sqs_scheduler_role.arn

    input = jsonencode({
      // 単にsqsにメッセージを送るだけなので, 適当な文字列でいい
      // MessageBody = "{ \"hello\": \"world\"}"
      MessageBody = jsonencode({
        hello = "world"
      })
      QueueUrl = aws_sqs_queue.my_queue.url
    })
    sqs_parameters {
      // [Amazon SQSメッセージグループ ID の使用 - Amazon Simple Queue Service](https://docs.aws.amazon.com/ja_jp/AWSSimpleQueueService/latest/SQSDeveloperGuide/using-messagegroupid-property.html)
      // 固定値であることにより, 順序保証, 一度のみの実行が保障される.
      message_group_id = "default"
    }
  }
}

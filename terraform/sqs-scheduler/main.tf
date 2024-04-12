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
  name                      = "my-queue.fifo"
  delay_seconds             = 90
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
  // FIFOキューは, 1回だけの処理と重複排除機能を備えている.
  // - 複数のconsumerがいる場合, 通常のキューでは同じメッセージが複数回処理される可能性があるが, FIFOキューでは1回だけ処理される.
  // - [Amazon Simple Queue Service の新機能 – 1 回だけの処理と重複排除機能を備えた FIFO キュー | Amazon Web Services ブログ](https://aws.amazon.com/jp/blogs/news/new-for-amazon-simple-queue-service-fifo-queues-with-exactly-once-delivery-deduplication/)
  fifo_queue = true
  // EventBridge Schedulerはat-least-onceである. 定期バッチを複数実行しないようにメッセージの重複削除をしている
  // - 5分間の重複排除を行う
  // - [Amazon EventBridge スケジューラとは - EventBridge スケジューラ](https://docs.aws.amazon.com/ja_jp/scheduler/latest/UserGuide/what-is-scheduler.html)
  // - [Amazon Simple Queue Service の新機能 – 1 回だけの処理と重複排除機能を備えた FIFO キュー | Amazon Web Services ブログ](https://aws.amazon.com/jp/blogs/news/new-for-amazon-simple-queue-service-fifo-queues-with-exactly-once-delivery-deduplication/)
  // - [Amazon SQSメッセージ重複排除ID の使用 - Amazon Simple Queue Service](https://docs.aws.amazon.com/ja_jp/AWSSimpleQueueService/latest/SQSDeveloperGuide/using-messagededuplicationid-property.html)
  content_based_deduplication = true
  // consumerの処理時間よりも長くするべき. 処理時間より短いとmaxReceiveCountの分、メッセージをreceive(consumeと同義)しようとする.
  visibility_timeout_seconds = 60
  redrive_policy = jsonencode(
    {
      deadLetterTargetArn = aws_sqs_queue.my_queue_dlq.arn
      // 処理途中でエラーになることによるリトライを避けたい場合は, 一度しか実行されないようにmaxReceiveCount = 1にする. 
      // ただし, 理想はべき等な処理にするべき & maxReceiveCountは1以上にするべき
      // https://docs.aws.amazon.com/ja_jp/AWSSimpleQueueService/latest/SQSDeveloperGuide/sqs-dead-letter-queues.html#sqs-dead-letter-queues-how-they-work
      //
      // maxReceiveCount = 1にしていい理由
      // - consumerがエラーが起きない処理ならば, エラーはAWS側のネットワークなど外部要因によるため滅多に発生しないはず.
      maxReceiveCount = 1
    }
  )
}

resource "aws_sqs_queue" "my_queue_dlq" {
  name                      = "my-queue-dlq.fifo"
  delay_seconds             = 90
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
  fifo_queue = true
  content_based_deduplication = true
  visibility_timeout_seconds = 60
}

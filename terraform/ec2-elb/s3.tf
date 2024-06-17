variable "access_log_bucket_name" {
  type = string
}

locals {
  // https://docs.aws.amazon.com/ja_jp/elasticloadbalancing/latest/application/enable-access-logging.html
  // 2022 年 8 月より前に利用可能になったリージョン
  // アジアパシフィック (東京) — 582318560864
  elb-account-id = {
    ap-northeast-1 = "582318560864"
  }
}

// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
resource "aws_s3_bucket" "alb_access_log" {
  bucket = var.access_log_bucket_name
}

// https://docs.aws.amazon.com/elasticloadbalancing/latest/application/enable-access-logging.html
resource "aws_s3_bucket_policy" "alb_access_log_policy" {
  bucket = aws_s3_bucket.alb_access_log.id
  policy = data.aws_iam_policy_document.alb_access_log.json
}

data "aws_iam_policy_document" "alb_access_log" {
  statement {
    effect    = "Allow"
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::${aws_s3_bucket.alb_access_log.id}/*"]
    principals {
      type        = "AWS"
      identifiers = [local.elb-account-id.ap-northeast-1]
    }
  }
}

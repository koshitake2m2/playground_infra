variable "bucket_name" {
  type = string
}

variable "cloudfront_arn" {
  type = string
}

output "bucket_id" {
  value = aws_s3_bucket.bucket.id
}

output "bucket_regional_domain_name" {
  value = aws_s3_bucket.bucket.bucket_regional_domain_name
}

// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
resource "aws_s3_bucket" "bucket" {
  bucket        = var.bucket_name
  force_destroy = true
}

// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object
resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.bucket.id
  key          = "index.html"
  source       = "./www/index.html"
  content_type = "text/html"
}

resource "aws_s3_object" "allow" {
  bucket       = aws_s3_bucket.bucket.id
  key          = "allow.html"
  source       = "./www/allow.html"
  content_type = "text/html"
}

resource "aws_s3_object" "deny" {
  bucket       = aws_s3_bucket.bucket.id
  key          = "deny.html"
  source       = "./www/deny.html"
  content_type = "text/html"
}


resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.bucket.id
  policy = jsonencode(
    {
      "Version" : "2008-10-17",
      "Id" : "PolicyForCloudFrontPrivateContent",
      "Statement" : [
        {
          "Sid" : "AllowCloudFrontServicePrincipal",
          "Effect" : "Allow",
          "Principal" : {
            "Service" : "cloudfront.amazonaws.com"
          },
          "Action" : "s3:GetObject",
          "Resource" : [
            "${aws_s3_bucket.bucket.arn}/*",
            "${aws_s3_bucket.bucket.arn}",
          ],
          "Condition" : {
            "StringEquals" : {
              "AWS:SourceArn" : "${var.cloudfront_arn}"
            }
          }
        },
      ]
    }
  )
}

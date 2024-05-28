variable "origin_id" {
  type = string
}
variable "domain_name" {
  type = string
}
output "cloudfront_arn" {
  value = aws_cloudfront_distribution.distribution.arn
}

// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_control
resource "aws_cloudfront_origin_access_control" "origin_access_control" {
  name                              = var.domain_name
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution
resource "aws_cloudfront_distribution" "distribution" {
  enabled             = true
  default_root_object = "index.html"

  origin {
    origin_id                = var.origin_id
    domain_name              = var.domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.origin_access_control.id
  }

  default_cache_behavior {
    target_origin_id       = var.origin_id
    viewer_protocol_policy = "allow-all"
    cached_methods         = ["GET", "HEAD"]
    allowed_methods        = ["GET", "HEAD"]
    forwarded_values {
      query_string = false
      headers      = []
      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

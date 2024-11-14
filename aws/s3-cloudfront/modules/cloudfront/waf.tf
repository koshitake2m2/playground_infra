// cloudfrontのwafはus-east-1で作るしかない
provider "aws" {
  region = "us-east-1"
}

// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl
resource "aws_wafv2_web_acl" "web_acl" {
  scope = "CLOUDFRONT"
  name  = "cloudfront_waf"
  default_action {
    allow {}
  }
  rule {
    name     = "deny-rule"
    priority = 1

    action {
      block {}
    }
    statement {
      byte_match_statement {
        field_to_match {
          uri_path {}
        }

        text_transformation {
          priority = 1
          type     = "NONE"
        }

        positional_constraint = "EXACTLY"
        search_string         = "/deny.html"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "deny_rule"
      sampled_requests_enabled   = false
    }

  }

  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "deny_rule"
    sampled_requests_enabled   = false
  }
}

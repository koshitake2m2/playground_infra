// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl
resource "aws_wafv2_web_acl" "alb_waf" {
  name  = "alb_waf"
  scope = "REGIONAL"

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
          // https://docs.aws.amazon.com/waf/latest/APIReference/API_TextTransformation.html
          type = "NONE"
        }

        positional_constraint = "STARTS_WITH"
        search_string         = "/deny"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "alb-waf-deny-rule-metric-name"
      sampled_requests_enabled   = false
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "alb-waf-metric-name"
    sampled_requests_enabled   = false
  }
}

resource "aws_wafv2_web_acl_association" "alb_waf_association" {
  web_acl_arn  = aws_wafv2_web_acl.alb_waf.arn
  resource_arn = aws_lb.alb.arn
}

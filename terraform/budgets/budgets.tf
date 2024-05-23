
locals {
  notification_settings = [
    {
      notification_type = "ACTUAL"
      threshold         = 85
    },
    {
      notification_type = "ACTUAL"
      threshold         = 100
    },
    {
      notification_type = "FORECASTED"
      threshold         = 100
    },
  ]
}

// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/budgets_budget
resource "aws_budgets_budget" "budget_1_usd" {
  name         = "My Monthly Cost Budget $1.00"
  budget_type  = "COST"
  time_unit    = "MONTHLY"
  limit_amount = "1.00"

  dynamic "notification" {
    for_each = local.notification_settings
    content {
      comparison_operator        = "GREATER_THAN"
      notification_type          = notification.value.notification_type
      subscriber_email_addresses = [var.subscriber_email_addresses]
      threshold                  = notification.value.threshold
      threshold_type             = "PERCENTAGE"
    }
  }
}

resource "aws_budgets_budget" "budget_5_usd" {
  name         = "My Monthly Cost Budget $5.00"
  budget_type  = "COST"
  time_unit    = "MONTHLY"
  limit_amount = "5.00"

  dynamic "notification" {
    for_each = local.notification_settings
    content {
      comparison_operator        = "GREATER_THAN"
      notification_type          = notification.value.notification_type
      subscriber_email_addresses = [var.subscriber_email_addresses]
      threshold                  = notification.value.threshold
      threshold_type             = "PERCENTAGE"
    }
  }
}

resource "aws_budgets_budget" "budget_10_usd" {
  name        = "My Monthly Cost Budget $10.00"
  budget_type = "COST"
  time_unit   = "MONTHLY"

  limit_amount = "10.00"
  dynamic "notification" {
    for_each = local.notification_settings
    content {
      comparison_operator        = "GREATER_THAN"
      notification_type          = notification.value.notification_type
      subscriber_email_addresses = [var.subscriber_email_addresses]
      threshold                  = notification.value.threshold
      threshold_type             = "PERCENTAGE"
    }
  }
}

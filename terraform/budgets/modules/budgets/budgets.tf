variable "subscriber_email_addresses" {
  type = list(string)
}

variable "budget_name" {
  type = string
}

variable "limit_amount" {
  type = string
}

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
resource "aws_budgets_budget" "main" {
  name         = var.budget_name
  budget_type  = "COST"
  time_unit    = "MONTHLY"
  limit_amount = var.limit_amount

  dynamic "notification" {
    for_each = local.notification_settings
    content {
      comparison_operator        = "GREATER_THAN"
      notification_type          = notification.value.notification_type
      subscriber_email_addresses = var.subscriber_email_addresses
      threshold                  = notification.value.threshold
      threshold_type             = "PERCENTAGE"
    }
  }
}

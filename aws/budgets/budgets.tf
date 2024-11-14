module "budgets_1_usd" {
  source                     = "./modules/budgets"
  subscriber_email_addresses = [var.email]
  budget_name                = "My Monthly Cost Budget $1.00"
  limit_amount               = "1.00"
}

module "budgets_5_usd" {
  source                     = "./modules/budgets"
  subscriber_email_addresses = [var.email]
  budget_name                = "My Monthly Cost Budget $5.00"
  limit_amount               = "5.00"
}

module "budgets_10_usd" {
  source                     = "./modules/budgets"
  subscriber_email_addresses = [var.email]
  budget_name                = "My Monthly Cost Budget $10.00"
  limit_amount               = "10.00"
}

// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group
resource "aws_cloudwatch_log_group" "app_api" {
  name              = "/ecs/app_api"
  retention_in_days = 1
}

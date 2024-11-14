module "github_actions" {
  source                      = "./modules/github-actions"
  aws_account_id              = var.aws_account_id
  repo_owner                  = var.repo_owner
  repo_name                   = var.repo_name
  thumbprint                  = var.thumbprint
  ecr_repository_name         = var.ecr_repository_name
  ecs_task_execution_role_arn = module.ecs.ecs_task_execution_role_arn
  cluster_name                = module.ecs.ecs_cluster_name
  service_name                = module.ecs.ecs_service_name
}

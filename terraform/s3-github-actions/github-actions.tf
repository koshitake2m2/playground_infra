module "github_actions" {
  source         = "./modules/github-actions"
  aws_account_id = var.aws_account_id
  repo_owner     = var.repo_owner
  repo_name      = var.repo_name
  bucket_arn     = module.bucket.bucket_arn
}

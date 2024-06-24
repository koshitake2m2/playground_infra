module "ecr" {
  source         = "./modules/ecr"
  ecr_repository = var.ecr_repository
}

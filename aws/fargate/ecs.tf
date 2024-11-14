module "ecs" {
  source                 = "./modules/ecs"
  vpc_id                 = module.vpc_a.vpc_id
  public_port            = local.public_port
  app_api_container_port = local.app_api_container_port
  app_api_image_uri      = var.app_api_image_uri
  vpc_subnet_ids         = module.vpc_a.subnet_ids
  alb_target_group_arn   = module.alb.alb_target_group_arn
}

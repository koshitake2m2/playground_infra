module "alb" {
  source                 = "./modules/alb"
  vpc_id                 = module.vpc_a.vpc_id
  subnet_ids             = module.vpc_a.subnet_ids
  public_port            = local.public_port
  app_api_container_port = local.app_api_container_port
}

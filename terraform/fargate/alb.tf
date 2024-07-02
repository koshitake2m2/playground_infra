module "alb" {
  source     = "./modules/alb"
  vpc_id     = module.vpc_a.vpc_id
  subnet_ids = module.vpc_a.subnet_ids
}

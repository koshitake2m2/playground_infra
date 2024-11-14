module "ec2_stop_scheduler" {
  source           = "./modules/scheduler"
  ec2_instance_id  = module.app_server_a.instance_id
  ec2_instance_arn = module.app_server_a.instance_arn
}

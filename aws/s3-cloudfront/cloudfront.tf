module "cloudfront" {
  source      = "./modules/cloudfront"
  origin_id   = module.bucket.bucket_id
  domain_name = module.bucket.bucket_regional_domain_name
}

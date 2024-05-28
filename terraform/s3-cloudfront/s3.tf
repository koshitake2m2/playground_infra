module "bucket" {
  source         = "./modules/s3"
  bucket_name    = var.bucket_name
  cloudfront_arn = module.cloudfront.cloudfront_arn
}

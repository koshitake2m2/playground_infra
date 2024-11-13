module "gcs" {
  source      = "./modules/gcs"
  bucket_name = var.bucket_name
}

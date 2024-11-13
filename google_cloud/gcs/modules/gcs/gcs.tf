variable "bucket_name" {
  type = string
}

resource "google_storage_bucket" "bucket" {
  name          = var.bucket_name
  location      = "US-EAST1"
  force_destroy = true
}

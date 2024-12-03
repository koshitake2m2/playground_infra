variable "gar_repository" {
  type = string
}

// https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/artifact_registry_repository
resource "google_artifact_registry_repository" "repository" {
  location      = "us-central1"
  repository_id = var.gar_repository
  format        = "DOCKER"
}

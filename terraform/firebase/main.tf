terraform {
  required_providers {
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 4.0"
    }
  }
}

provider "google-beta" {
  # Configures the provider to use the resource block's specified project for quota checks.
  user_project_override = true
}

# TODO: projectをいい感じにimport or 作成できるようにする
# resource "google_project" "default" {
#   provider   = google-beta
#   name       = "my-project-name"
#   project_id = var.google_project_project_id
#   # billing_account = "000000-000000-000000"

#   labels = {
#     "firebase" = "enabled"
#   }
# }

resource "google_project_service" "default" {
  provider = google-beta
  # project  = google_project.default.project_id
  project = var.google_project_project_id
  for_each = toset([
    # "cloudbilling.googleapis.com",
    # "cloudresourcemanager.googleapis.com",
    "firebase.googleapis.com",
    # Enabling the ServiceUsage API allows the new project to be quota checked from now on.
    "serviceusage.googleapis.com",
  ])
  service = each.key

  # Don't disable the service if the resource block is removed by accident.
  disable_on_destroy = false
}

resource "google_firebase_project" "default" {
  provider = google-beta
  # project  = google_project.default.project_id
  project = var.google_project_project_id

  # Waits for the required APIs to be enabled.
  depends_on = [
    google_project_service.default
  ]
}

# Creates a Firebase Android App in the new project created above.
resource "google_firebase_android_app" "default" {
  provider = google-beta
  # project  = google_project.default.project_id
  project      = var.google_project_project_id
  display_name = "${var.project_name}_android_app"
  package_name = var.google_firebase_android_app_package_name

  # Wait for Firebase to be enabled in the Google Cloud project before creating this App.
  depends_on = [
    google_firebase_project.default,
  ]
}

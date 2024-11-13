terraform {
  required_providers {
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 4.0"
    }
  }
}

provider "google-beta" {
  user_project_override = false
}

# TODO: こちらのエラーを解決する→ make sure you have the `roles/resourcemanager.projectCreator` permission
# TODO: organizationを利用できるようにして上記のパーミッションを持ったロールを作る
resource "google_project" "default" {
  provider        = google-beta
  name            = var.project_name
  project_id      = var.project_id
  billing_account = var.billing_account

  labels = {
    "firebase" = "enabled"
  }
}

resource "google_project_service" "default" {
  provider = google-beta
  project  = google_project.default.project_id
  for_each = toset([
    "cloudbilling.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    # Enabling the ServiceUsage API allows the new project to be quota checked from now on.
    "serviceusage.googleapis.com",
    "firebase.googleapis.com",
    "firestore.googleapis.com",
    "firebaserules.googleapis.com",
    "identitytoolkit.googleapis.com",


  ])
  service = each.key

  # Don't disable the service if the resource block is removed by accident.
  disable_on_destroy = false
}

resource "google_firebase_project" "default" {
  provider = google-beta
  project  = google_project.default.project_id

  # Waits for the required APIs to be enabled.
  depends_on = [
    google_project_service.default
  ]
}

# Creates a Firebase Android App in the new project created above.
resource "google_firebase_android_app" "default" {
  provider     = google-beta
  project      = var.project_id
  display_name = "${var.project_name}_android_app"
  package_name = var.android_app_package_name

  # Wait for Firebase to be enabled in the Google Cloud project before creating this App.
  depends_on = [
    google_firebase_project.default,
  ]
}

resource "google_firestore_database" "default" {
  project                     = var.project_id
  name                        = "firestore"
  location_id                 = "asia-northeast1"
  type                        = "FIRESTORE_NATIVE"
  concurrency_mode            = "OPTIMISTIC"
  app_engine_integration_mode = "DISABLED"

  depends_on = [
    google_firebase_project.default,
  ]
}

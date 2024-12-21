output "vpc_name" {
  value = google_compute_network.vpc.name
}
output "subnet_name" {
  value = google_compute_subnetwork.subnet.name
}

// https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network
resource "google_compute_network" "vpc" {
  name                    = "vpc"
  auto_create_subnetworks = false
}

// https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork
resource "google_compute_subnetwork" "subnet" {
  name                     = "subnet"
  region                   = "us-central1"
  network                  = google_compute_network.vpc.id
  ip_cidr_range            = "10.0.0.0/24"
  private_ip_google_access = true
}

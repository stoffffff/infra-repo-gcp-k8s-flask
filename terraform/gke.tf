resource "google_container_cluster" "primary" {
  name     = var.gke_cluster_name
  location = var.region

  enable_autopilot = true

  network    = google_compute_network.vpc_network.name
  subnetwork = google_compute_subnetwork.staging_subnet.name
  
}

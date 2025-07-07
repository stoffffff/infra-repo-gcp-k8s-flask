resource "google_container_cluster" "primary" {
  name               = var.gke_cluster_name
  location           = var.region
  initial_node_count = 1
  network            = google_compute_network.vpc_network.name
  subnetwork         = google_compute_subnetwork.staging_subnet.name

  remove_default_node_pool = true
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }
}

resource "google_container_node_pool" "primary_nodes" {
  name       = "primary-node-pool"
  cluster    = google_container_cluster.primary.name
  location   = var.region
  node_count = 2

  node_config {
    machine_type = "n1-standard-1"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
    workload_metadata_config {
      mode = "GKE_METADATA"
    }
  }

  depends_on = [google_container_cluster.primary]
}

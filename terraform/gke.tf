resource "google_container_cluster" "primary" {
  name     = var.gke_cluster_name
  location = var.region                   
  network  = google_compute_network.vpc_network.name
  subnetwork = google_compute_subnetwork.staging_subnet.name

  remove_default_node_pool = true

  initial_node_count = 1
  
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  logging_service    = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"
}

resource "google_container_node_pool" "primary_nodes" {
  name     = "flask-app-pool"
  cluster  = google_container_cluster.primary.name
  location = var.region
  node_count = 1

  node_config {
    machine_type = "e2-micro"          
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]

    workload_metadata_config {
      mode = "GKE_METADATA"
    }

    tags = ["flask-app-node"]
  }

  autoscaling {
    min_node_count = 1
    max_node_count = 2
  }

  management {
    auto_upgrade = true
    auto_repair  = true
  }

  depends_on = [google_container_cluster.primary]
}

resource "google_container_cluster" "primary" {
  name     = var.gke_cluster_name
  location = var.region

  network    = google_compute_network.vpc_network.name
  subnetwork = google_compute_subnetwork.staging_subnet.name

  initial_node_count       = 1
  remove_default_node_pool = true

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }
}

resource "google_container_node_pool" "primary_nodes" {
  name     = "primary-nodes"
  cluster  = google_container_cluster.primary.name
  location = google_container_cluster.primary.location

  node_count = 3

  node_config {
    machine_type = "e2-micro"        
    disk_type    = "pd-ssd"          
    disk_size_gb = 30                
    image_type   = "COS_CONTAINERD"  
  }
}

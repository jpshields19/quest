# resource "google_container_cluster" "cluster" {
#   name     = "${var.cluster_name}"
#   location = var.region

#   remove_default_node_pool = true
#   initial_node_count       = 1

#   network    = google_compute_network.network.name
#   subnetwork = google_compute_subnetwork.subnet.name
# }

# resource google_container_node_pool pool {
#   name               = "${var.cluster_name}-nodes"
#   cluster            = var.cluster_name
#   initial_node_count = 1
#   location           = var.region
#   node_config {
#     disk_size_gb    = "10"
#     labels          = {general: "node"}
#     machine_type    = "n1-standard-1"
#     oauth_scopes    = ["https://www.googleapis.com/auth/cloud-platform"]
#     preemptible     = true
#     service_account = google_service_account.cluster.email
#     tags            = ["general", "${var.cluster_name}"]
#   }
    
#   autoscaling {
#     max_node_count = 2
#     min_node_count = 1
#   }
  
# }
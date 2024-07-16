resource google_compute_network network {
  name                    = "${var.cluster_name}-network"
  auto_create_subnetworks = false
  project                 = var.project_id
}

resource "google_compute_subnetwork" "subnet" {
  name          = "${var.project_id}-subnet"
  region        = var.region
  network       = google_compute_network.network.name
  ip_cidr_range = "10.240.0.0/24"
}

# google_compute_router.router:
resource "google_compute_router" "router" {
    encrypted_interconnect_router = false
    name                          = "router"
    network                       = google_compute_network.network.id
    project                       = var.project_id
    region                        = var.region
}

# google_compute_router_nat.default:
resource "google_compute_router_nat" "default" {
    auto_network_tier                   = "STANDARD"
    drain_nat_ips                       = []
    enable_dynamic_port_allocation      = false
    enable_endpoint_independent_mapping = false
    endpoint_types                      = [
        "ENDPOINT_TYPE_VM",
    ]
    icmp_idle_timeout_sec               = 30
    max_ports_per_vm                    = 0
    min_ports_per_vm                    = 64
    name                                = "gateway"
    nat_ip_allocate_option              = "AUTO_ONLY"
    nat_ips                             = []
    project                             = var.project_id
    region                              = var.region
    router                              = google_compute_router.router.name
    source_subnetwork_ip_ranges_to_nat  = "ALL_SUBNETWORKS_ALL_IP_RANGES"
    tcp_established_idle_timeout_sec    = 1200
    tcp_time_wait_timeout_sec           = 120
    tcp_transitory_idle_timeout_sec     = 30
    udp_idle_timeout_sec                = 30

    log_config {
        enable = false
        filter = "ALL"
    }
}
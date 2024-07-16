# Reserve an external IP address
resource "google_compute_global_address" "default" {
  name = "my-static-ip-address"
}

resource "google_compute_address" "gke" {
  name = "gke-loadbalancer-address"
}

output "loadbalancer-ip" {
  value = google_compute_global_address.default.address
}

output "gke-loadbalancer-ip" {
  value = google_compute_address.gke.address
}

# Generate private key
resource "tls_private_key" "default" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# Generate self-signed certificate
resource "tls_self_signed_cert" "default" {
  private_key_pem = tls_private_key.default.private_key_pem

  subject {
    common_name  = "service.tryquests.xyz"
    organization = "Quest"
    
  }
  dns_names = ["service.tryquests.xyz"]
  ip_addresses = [google_compute_global_address.default.address]

  validity_period_hours = 8760

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

# Create SSL certificate resource
resource "google_compute_ssl_certificate" "default" {
  name        = "my-self-signed-cert"
  private_key = tls_private_key.default.private_key_pem
  certificate = tls_self_signed_cert.default.cert_pem
}

resource "google_compute_managed_ssl_certificate" "default" {
  name = "tryquest-cert"

  managed {
    domains = ["service.tryquests.xyz"]
  }
}

#Create NEG group
resource "google_compute_region_network_endpoint_group" "quest_neg" {
  name                  = "quest-neg"
  network_endpoint_type = "SERVERLESS"
  region                = "us-central1"
  
  cloud_run {
    service = "quest"
  }
}

# Create a Google Cloud Load Balancer
resource "google_compute_global_forwarding_rule" "default" {
  name                  = "cloud-run-load-balancer"
  target                = google_compute_target_https_proxy.quest_proxy.id
  port_range            = "443"
  ip_address            = google_compute_global_address.default.address
  load_balancing_scheme = "EXTERNAL"
}

resource "google_compute_backend_service" "quest_backend" {
  name                  = "quest-backend"
  load_balancing_scheme = "EXTERNAL"
  
  backend {
    group = google_compute_region_network_endpoint_group.quest_neg.id
  }
}

resource "google_compute_url_map" "quest_url_map" {
  name            = "quest-url"
  default_service = google_compute_backend_service.quest_backend.id
}

resource "google_compute_target_https_proxy" "quest_proxy" {
  name             = "quest-proxy"
  url_map          = google_compute_url_map.quest_url_map.id
  ssl_certificates = [google_compute_managed_ssl_certificate.default.id]
}
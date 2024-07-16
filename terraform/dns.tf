# google_dns_managed_zone.tryquests:
resource "google_dns_managed_zone" "tryquests" {
    dns_name         = "tryquests.xyz."
    force_destroy    = false
    name             = "tryquests"
    project          = var.project_id
    visibility       = "public"

    dnssec_config {
        kind          = "dns#managedZoneDnsSecConfig"
        non_existence = "nsec3"
        state         = "on"

        default_key_specs {
            algorithm  = "rsasha256"
            key_length = 2048
            key_type   = "keySigning"
            kind       = "dns#dnsKeySpec"
        }
        default_key_specs {
            algorithm  = "rsasha256"
            key_length = 1024
            key_type   = "zoneSigning"
            kind       = "dns#dnsKeySpec"
        }
    }
}

# google_dns_record_set.base_record:
resource "google_dns_record_set" "base_record" {
    managed_zone = google_dns_managed_zone.tryquests.name
    name         = "tryquests.xyz."
    project      = var.project_id
    rrdatas      = [
        google_compute_address.gke.address,
    ]
    ttl          = 300
    type         = "A"
}

# google_dns_record_set.service_record:
resource "google_dns_record_set" "service_record" {
    managed_zone = google_dns_managed_zone.tryquests.name
    name         = "service.tryquests.xyz."
    project      = var.project_id
    rrdatas      = [
        google_compute_global_address.default.address,
    ]
    ttl          = 300
    type         = "A"
}

data "google_dns_keys" "keys" {
  managed_zone = google_dns_managed_zone.tryquests.name
}

output "nameservers" {
  value       = google_dns_managed_zone.tryquests.name_servers
  description = "The list of nameservers for the managed zone"
}

output "ds_record_info" {
  value = [for key in data.google_dns_keys.keys.key_signing_keys : 
    "${key.ds_record}"
  ]
  description = "The DS record information for this managed zone"
}
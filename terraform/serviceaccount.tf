data "google_service_account" "github-terraform" {
  account_id   = "github-terraform"
}

# resource "google_service_account_key" "github-terraform" {
#   service_account_id = data.google_service_account.github-terraform.name
# }

# resource "google_storage_bucket_iam_member" "member" {
#   bucket = "justin-quest-tf"
#   role   = "roles/storage.objectAdmin"
#   member = "serviceAccount:${google_service_account.github-terraform.email}"
# }

resource google_service_account cluster {
  account_id = "${var.cluster_name}-sa"
  display_name = "Service Account for ${var.cluster_name}"
}

resource google_service_account letsencrypt {
  account_id = "letsencrypt-google"
  display_name = "Service Account for dns solver"
}

resource "google_project_iam_member" "letsencrypt" {
  project = var.project_id
  role = "roles/dns.admin"
  member = "serviceAccount:${google_service_account.letsencrypt.email}"
}

resource "google_service_account_iam_member" "workload_identity_binding" {
  service_account_id = "projects/${var.project_id}/serviceAccounts/${google_service_account.letsencrypt.email}"
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:justin-quest.svc.id.goog[cert-manager/cert-manager]"
}


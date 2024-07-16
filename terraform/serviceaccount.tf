resource "google_service_account" "github" {
  account_id   = "github"
  display_name = "github"
  description  = "Service account created by Terraform"
}

resource "google_service_account_key" "github" {
  service_account_id = google_service_account.github.name
}

resource "google_storage_bucket_iam_member" "member" {
  bucket = "justin-quest-tf"
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.github.email}"
}

resource "google_project_iam_member" "github-roles" {
  for_each = toset(var.github-roles)
  project = var.project_id
  role = each.key
  member = "serviceAccount:${google_service_account.github.email}"
  
}

data google_compute_default_service_account default {
}

resource "google_service_account_iam_member" "project-cloud-run" {
  service_account_id = data.google_compute_default_service_account.default.name
  role               = "roles/iam.serviceAccountUser"
  member             = "serviceAccount:${google_service_account.github.email}"
}


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


resource "google_service_account" "github-terraform" {
  account_id   = "github-terraform"
  display_name = "github-terraform"
  description  = "Service account created by Terraform"
}

resource "google_service_account_key" "github-terraform" {
  service_account_id = google_service_account.github-terraform.name
}

resource "google_storage_bucket_iam_member" "member" {
  bucket = "justin-quest-tf"
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.github-terraform.email}"
}

resource "google_project_iam_member" "github-roles" {
  for_each = toset(var.github-roles)
  project = var.project_id
  role = each.key
  member = "serviceAccount:${google_service_account.github-terraform.email}"
  
}

data google_compute_default_service_account default {
}

resource "google_service_account_iam_member" "project-cloud-run" {
  service_account_id = data.google_compute_default_service_account.default.name
  role               = "roles/iam.serviceAccountUser"
  member             = "serviceAccount:${google_service_account.github-terraform.email}"
}

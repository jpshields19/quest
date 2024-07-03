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

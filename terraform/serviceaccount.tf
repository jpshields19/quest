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

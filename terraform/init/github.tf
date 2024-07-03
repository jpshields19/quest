# resource "github_actions_secret" "gcp-key" {
#   repository       = var.repo_name
#   secret_name      = "GCP_KEY"
#   plaintext_value  = google_service_account_key.github-terraform.private_key
# }
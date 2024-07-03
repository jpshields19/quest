resource "google_service_account" "my_service_account" {
  account_id   = "github-terraform"
  display_name = "github-terraform"
  description  = "Service account created by Terraform"
}
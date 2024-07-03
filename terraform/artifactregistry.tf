resource "google_artifact_registry_repository" "repo" {
  location      = "us-central1"
  repository_id = "${var.project_id}"
  description   = "Docker image repository"
  format        = "DOCKER"
}
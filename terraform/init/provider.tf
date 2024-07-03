provider google {
  project     = var.project_id
  region      = var.region
  # credentials = pathexpand(var.credentials)
}

terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    #   version     = "4.59.0"
    }
  }
}
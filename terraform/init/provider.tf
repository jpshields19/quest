provider google {
  project     = var.project_id
  region      = var.region
  # credentials = pathexpand(var.credentials)
}

provider "github" {
  owner = "jpshields19"
  token = ""
}

terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}
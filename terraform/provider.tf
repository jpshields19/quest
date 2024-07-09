provider google {
  project     = var.project_id
  region      = var.region
  # credentials = pathexpand(var.credentials)
}

provider "tls" {
  
}

terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0" 
    }
  }
}

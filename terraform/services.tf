#Automatically enable any gcp APIs needed for the project

resource google_project_service kubernetes {
  project                    = var.project_id
  service                    = "container.googleapis.com"
  disable_dependent_services = false
}

resource google_project_service compute {
  project                    = var.project_id
  service                    = "compute.googleapis.com"
  disable_dependent_services = false
}

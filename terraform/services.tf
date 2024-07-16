#Automatically enable any gcp APIs needed for the project

resource google_project_service services {
  for_each                    = toset(var.services)
  project                     = var.project_id
  service                     = each.key
  disable_dependent_services  = false
}

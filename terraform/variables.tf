variable "project_id" {
    default = "justin-quest"
}

variable "cluster_name" {
    default = "gke-quest"
}

variable "region" {
    default = "us-central1"
}   

variable "services" {
    default = [
        "iam.googleapis.com",
        "container.googleapis.com",
        "compute.googleapis.com",
        "artifactregistry.googleapis.com",
        "run.googleapis.com",
        "certificatemanager.googleapis.com"
    ]
}

variable "github-roles" {
    default = [
        "roles/artifactregistry.admin",
        "roles/iam.serviceAccountCreator",
        "roles/run.admin",
        "roles/iam.serviceAccountUser",
    ]
  
}
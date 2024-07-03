variable "project_id" {
    default = "justin-quest"
}

variable "cluster_name" {
    default = "gke-quest"
}

variable "region" {
    default = "us-central1"
}   

variable "repo_name" {
    default = "quest"
}

variable "services" {
    default = [
        "iam.googleapis.com",
        "container.googleapis.com",
        "compute.googleapis.com",
        "artifactregistry.googleapis.com",
        
    ]
}
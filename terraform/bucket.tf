# google_storage_bucket.default:
resource "google_storage_bucket" "default" {
    default_event_based_hold    = false
    enable_object_retention     = false
    force_destroy               = false
    labels                      = {}
    location                    = var.region
    name                        = "justin-quest-tf"
    project                     = var.project_id
    public_access_prevention    = "enforced"
    requester_pays              = false
    storage_class               = "STANDARD"
    uniform_bucket_level_access = true

    soft_delete_policy {
        retention_duration_seconds = 604800
    }
}
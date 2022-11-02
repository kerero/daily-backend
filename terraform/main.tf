resource "google_cloud_run_service" "daily" {
  name     = "daily"
  location = var.region

  template {
    spec {
      containers {
        image = var.daily_image_url
        resources {
          limits = {
            "cpu"    = "80m"
            "memory" = "128Mi"
          }
        }
      }
      container_concurrency = "1000"
      timeout_seconds       = "3600"
    }


    metadata {
      name = var.revision_name
      annotations = {
        "autoscaling.knative.dev/maxScale" = "1"
        "autoscaling.knative.dev/minScale" = "0"
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

data "google_iam_policy" "noauth" {
  depends_on = [
    google_cloud_run_service.daily
  ]
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  depends_on = [
    data.google_iam_policy.noauth,
  ]
  location = google_cloud_run_service.daily.location
  project  = google_cloud_run_service.daily.project
  service  = google_cloud_run_service.daily.name

  policy_data = data.google_iam_policy.noauth.policy_data
}

resource "google_storage_bucket" "bucket" {
  name = "appengine-static-content-${var.project}"
}

resource "google_storage_bucket_object" "object" {
  name   = "hello-world.zip"
  bucket = google_storage_bucket.bucket.name
  source = "./app_engine/default-app-node.zip"
}

resource "google_app_engine_application" "app" {
    project     = data.google_project.project.project_id
    location_id = var.location
}

resource "google_app_engine_standard_app_version" "default" {
  version_id = "v1"
  service    = "default"
  runtime    = "nodejs10"

  entrypoint {
    shell = "node ./app.js"
  }

  deployment {
    zip {
      source_url = "https://storage.googleapis.com/${google_storage_bucket.bucket.name}/${google_storage_bucket_object.object.name}"
    }
  }

  env_variables = {
    port = "8080"
  }

  delete_service_on_destroy = true
}
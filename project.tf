provider "google" {
    project = var.project
    region = var.region
}

data "google_project" "project" {}

resource "google_project_service" "service" {
  for_each = toset([
    "appengine.googleapis.com",
    "appengineflex.googleapis.com",
    "firestore.googleapis.com"
  ])

  service = each.key

  disable_on_destroy = false
}




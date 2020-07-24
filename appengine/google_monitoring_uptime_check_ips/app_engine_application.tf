resource "google_app_engine_application" "pkg-gcp" {
  depends_on  = [google_project_service.pkg-gcp_appengine]
  location_id = lookup(var.common, "region")
}

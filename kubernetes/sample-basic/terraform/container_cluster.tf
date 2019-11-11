# Reference
# https://www.terraform.io/docs/providers/google/r/container_cluster.html

resource "google_container_cluster" "gcc_priary" {
  name     = "igrs-test"
  location = "us-central1"

  remove_default_node_pool = true
  initial_node_count       = 1

  master_auth {
    username = "iganari"
    password = "hogehogefugafuga"

    client_certificate_config {
      issue_client_certificate = false
    }
  }

  network = google_compute_network.gcn_default.name
  subnetwork = google_compute_subnetwork.gcs_default.name
}
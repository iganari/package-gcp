# refs
# https://www.terraform.io/docs/providers/google/r/container_cluster.html

resource "google_container_node_pool" "gcnp_default" {
  name       = "my-node-pool"
  location   = "us-central1"
  cluster    = google_container_cluster.gcc_priary.name
  node_count = 1


  # ゾーンあたりのnode数なので、全体のnode数のことではないの注意
  autoscaling {
      min_node_count = 1
      max_node_count = 1
  }

  management {
    auto_repair = true
  }

  node_config {
    preemptible  = true
    machine_type = "n1-standard-1"

    metadata = {
      disable-legacy-endpoints = "true"
    }

    # oauth_scopes = [
    #     "https://www.googleapis.com/auth/logging.write",
    #     "https://www.googleapis.com/auth/monitoring",
    # ]
  }
}
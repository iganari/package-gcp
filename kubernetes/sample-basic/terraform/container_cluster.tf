# Reference
# https://www.terraform.io/docs/providers/google/r/container_cluster.html

resource "google_container_cluster" "gcc_priary" {
  name     = ""
  location = ""

  remove_default_node_pool = true
  initial_node_count       = 1
}
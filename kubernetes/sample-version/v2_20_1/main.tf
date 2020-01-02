terraform {
  required_version = "0.12.18"
}

provider "google" {
  project = var.project
  version = "2.20.1" # https://github.com/terraform-providers/terraform-provider-google/releases
}
provider "google-beta" {
  project = var.project
  version = "2.20.1" # https://github.com/terraform-providers/terraform-provider-google/releases
}


resource "google_compute_network" "gcn_tf_diff" {
  name                    = lookup(var.network, "nw_name")
  auto_create_subnetworks = lookup(var.network, "auto_create")
}
resource "google_compute_subnetwork" "gcs_tf_diff" {
  # provider = google-beta

  network = google_compute_network.gcn_tf_diff.self_link

  name          = lookup(var.network, "sb_name")
  ip_cidr_range = lookup(var.network, "sb_cidr")
  region        = lookup(var.network, "sb_region")

}

resource "google_container_cluster" "gcc_tf_diff" {
  provider = google-beta
  name     = lookup(var.cluster, "name")
  location = google_compute_subnetwork.gcs_tf_diff.region

  network    = google_compute_network.gcn_tf_diff.name
  subnetwork = google_compute_subnetwork.gcs_tf_diff.name

  remove_default_node_pool = true
  initial_node_count       = 1


  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }

  pod_security_policy_config {
    enabled = true
  }

}

resource "google_container_node_pool" "gcnp_tf_diff" {
  name       = lookup(var.node_pool, "name")
  location   = google_compute_subnetwork.gcs_tf_diff.region
  cluster    = google_container_cluster.gcc_tf_diff.name
  node_count = 1

  node_config {
    preemptible  = true
    machine_type = "n1-standard-1"

    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}

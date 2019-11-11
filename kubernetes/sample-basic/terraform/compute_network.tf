### VPC Networks
resource "google_compute_network" "gcn_default" {
    # provider = "google-beta"

    name = "igrs-network"
    auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "gcs_default" {
    # provider = "google-beta"
    network = google_compute_network.gcn_default.name

    name = "igrs-subnet"
    ip_cidr_range = "192.168.101.0/24"

    region = "us-central1"

}
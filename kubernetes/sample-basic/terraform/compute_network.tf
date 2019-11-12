### VPC Networks
resource "google_compute_network" "gcn_default" {
  # provider = "google-beta"

  name                    = "${lookup(var.network, "nw-name")}"
  auto_create_subnetworks = "${lookup(var.network, "nw-auto_create_subnetworks")}"
}

resource "google_compute_subnetwork" "gcs_default" {
  # provider = "google-beta"
  network = google_compute_network.gcn_default.name

  name          = "${lookup(var.network, "sb-name")}"
  ip_cidr_range = "${lookup(var.network, "sb-ip_cidr_range")}"

  region = "${lookup(var.network, "sb-region")}"

}
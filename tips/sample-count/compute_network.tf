### VPC Networks

resource "google_compute_network" "gcn_test" {

  count = 49

  name                    = "${lookup(var.network, "nw-name")}-${count.index + 1}"
  auto_create_subnetworks = "${lookup(var.network, "nw-auto-create-subnetworks")}"
}

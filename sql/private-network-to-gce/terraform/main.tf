#------------------------------------------------------------------------------
# Prepare Terraform
#------------------------------------------------------------------------------

locals {
  gcp_project_id = "Your GCP Project ID"
  region         = "asia-northeast1"
  zone           = "asia-northeast1-a"
  common         = "gce2slqwithpritf"
}

terraform {
  required_version = "0.14.4"
}

provider "google" {
  project = local.gcp_project_id
  region  = local.region
  zone    = local.zone
}

provider "google-beta" {
  project = local.gcp_project_id
  region  = local.region
  zone    = local.zone
}

resource "google_project_service" "serviceusage" {
  service            = "serviceusage.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "main" {
  depends_on = [google_project_service.serviceusage]
  provider   = google-beta

  service            = "servicenetworking.googleapis.com"
  disable_on_destroy = false
}


#------------------------------------------------------------------------------
# VPC network
#------------------------------------------------------------------------------

resource "google_compute_network" "main" {
  provider = google-beta

  name                    = "${local.common}-nw"
  auto_create_subnetworks = "false"
  routing_mode            = "REGIONAL"
}

resource "google_compute_subnetwork" "main" {
  provider = google-beta

  name          = "${local.common}-sub"
  network       = google_compute_network.main.self_link
  ip_cidr_range = "10.146.0.0/20"
  region        = local.region

  private_ip_google_access = true
}

resource "google_compute_firewall" "main" {
  provider = google-beta

  name    = "${google_compute_network.main.name}-test-firewall"
  network = google_compute_network.main.name

  priority = 1000

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_address" "main" {
  provider     = google-beta
  name         = "${local.common}-ip"
  address_type = "EXTERNAL"
  region       = local.region
}


#------------------------------------------------------------------------------
# Cloud SQL Instance with Private IP Addess
#------------------------------------------------------------------------------

resource "google_compute_global_address" "main" {
  provider = google-beta

  name          = "${local.common}-vpc-peer"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.main.id
}

resource "google_service_networking_connection" "main" {
  provider = google-beta

  network                 = google_compute_network.main.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.main.name]
}

resource "random_id" "db_name_suffix" {
  byte_length = 6
}

resource "google_sql_database_instance" "main" {
  provider   = google-beta
  depends_on = [google_service_networking_connection.main]

  name             = "${local.common}-db-${random_id.db_name_suffix.hex}"
  region           = local.region
  database_version = "MYSQL_8_0"

  settings {
    tier = "db-n1-standard-1" # minimum tier: db-f1-micro 
    ip_configuration {
      ipv4_enabled    = false
      private_network = google_compute_network.main.id
    }
  }
  deletion_protection = false
}

resource "google_sql_user" "main" {
  provider = google-beta

  instance = google_sql_database_instance.main.name
  name     = "db_admin"
  password = "changeme"
  host     = "%"
}


#------------------------------------------------------------------------------
# Bastion Server
#------------------------------------------------------------------------------

resource "google_compute_instance" "main" {
  name         = "${local.common}-vm"
  machine_type = "f1-micro"
  zone         = local.zone

  boot_disk {
    auto_delete = true
    initialize_params {
      image = "ubuntu-minimal-2004-focal-v20210130"
      size  = "30"
      type  = "pd-standard"
    }
  }

  network_interface {
    network    = google_compute_network.main.self_link
    subnetwork = google_compute_subnetwork.main.self_link
    access_config {
      nat_ip = google_compute_address.main.address
    }
  }
}

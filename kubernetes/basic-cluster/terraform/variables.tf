variable "network" {
  default = {
    nw-name                    = "iganari-nw"
    nw-auto_create_subnetworks = "false"
    sb-name                    = "iganari-sb"
    sb-ip_cidr_range           = "192.168.101.0/24"
    sb-region                  = "us-central1" # asia-northeast1
  }
}

variable "cluster" {
  default = {
    pr-name     = "iganari-k8s-primary"
    master-name = "k8s-admin"
    master-pass = "hogehogefugafuga"
  }
}

variable "node-pool" {
  default = {
    np-name = "iganari-k8s-node"
    # master-name     = "k8s-admin"
    # master-pass     = "hogehogefugafuga"
    np-machine-type = "n1-standard-1"

  }
}

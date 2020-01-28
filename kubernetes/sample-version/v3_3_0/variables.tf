variable "project" {
  default = "iganari-tf-diff-v3"
}

variable "network" {
  default = {
    "nw_name"     = "tf-diff-v3-nw"
    "auto_create" = "false"
    "sb_name"     = "tf-diff-v3-sb"
    "sb_cidr"     = "10.2.0.0/16"
    "sb_region"   = "us-central1"
    "sb_sec_name_cls" = "tf-diff-v3-sb-secondary-cluster"
    "sb_sec_cidr_cls" = "10.100.0.0/16"
    "sb_sec_name_srv" = "tf-diff-v3-sb-secondary-service"
    "sb_sec_cidr_srv" = "10.101.0.0/16"
  }
}

variable "cluster" {
  default = {
    "name"     = "tf-diff-v3"
    "username" = ""
    "password" = ""
  }
}

variable "node_pool" {
  default = {
    "name" = "tf-diff-v3-node"
  }
}

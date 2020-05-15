# variable "common" {
#   
# }

variable "network" {
  type = "map"
  default = {
    nw-name                    = "hogehoge"
    nw-auto-create-subnetworks = "false"
  }
}
variable "image-hiyoko" {
  default = [
    "animal_mark_hiyoko.png",
    "hiyoko_baby.png",
    "hiyoko.png",
    "niwatori_hiyoko_koushin.png"
  ]
}

variable "database" {
  type = "map"
  default = {
    "db_name"    = "pkg-gcp-sql"
    "db_version" = "MYSQL_5_7"
    "db_region"  = "us-central1"
  }
}
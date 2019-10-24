# resource "random_id" "bucket-suffix" {
#     byte_length = 4
# 
# 
# }


resource "random_string" "bucket-suffix" {
    length = 8
    upper = false
    lower = true
    number = false
    special = false
}

output "output-random-string" {
    value = "${random_string.bucket-suffix}"
}



resource "google_storage_bucket" "gsb" {
  name     = "image-store-bucket-${random_string.bucket-suffix.id}"
  location = "asia-northeast1"

  project = "${terraform.workspace}"
  storage_class = "REGIONAL"
  force_destroy = false


  # website {
  #   main_page_suffix = "index.html"
  #   not_found_page   = "404.html"
  # }
}
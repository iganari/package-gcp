# resource "google_storage_bucket" "image-store" {
#   name     = "image-store-bucket-1024-02"
#   location = "asia-northeast1"
# 
#   project = "${terraform.workspace}"
#   storage_class = "REGIONAL"
#   force_destroy = false
# 
# 
#   # website {
#   #   main_page_suffix = "index.html"
#   #   not_found_page   = "404.html"
#   # }
# }
# ============================== #
#        Test bucket 01          #
# ============================== #

resource "random_string" "bucket-suffix-01" {
  length  = 8
  upper   = false
  lower   = true
  number  = false
  special = false
}


# count
resource "google_storage_bucket" "gsb-default" {
  # name     = "bucket-test-${random_string.bucket-suffix-01.id}"
  count = 50

  name     = "bucket-test-${count.index}-${random_string.bucket-suffix-01.id}"
  location = "asia-northeast1"

  project       = "${terraform.workspace}"
  storage_class = "REGIONAL"
  force_destroy = false

}












# # ============================== #
# #        Test bucket 02          #
# # ============================== #
# 
# resource "random_string" "bucket-suffix-02" {
#   length  = 8
#   upper   = false
#   lower   = true
#   number  = false
#   special = false
# }
# 
# resource "google_storage_bucket" "gsb-02" {
#   name     = "bucket-test-public-02-${random_string.bucket-suffix-02.id}"
#   location = "asia-northeast1"
# 
#   project       = "${terraform.workspace}"
#   storage_class = "REGIONAL"
#   force_destroy = false
# }
# 
# resource "google_storage_bucket_access_control" "gsbac_public_rule" {
#   bucket = "${google_storage_bucket.gsb-02.name}"
#   role   = "READER"
#   entity = "allUsers"
# }
# 
# # ============================== #
# #        Test bucket 03          #
# # ============================== #
# 
# ### resource "random_string" "bucket-suffix-03" {
# ###   length  = 8
# ###   upper   = false
# ###   lower   = true
# ###   number  = false
# ###   special = false
# ### }
# ### 
# ### resource "google_storage_bucket" "gsb-03" {
# ###   name     = "bucket-test-public-03-${random_string.bucket-suffix-03.id}"
# ###   location = "asia-northeast1"
# ### 
# ###   project       = "${terraform.workspace}"
# ###   storage_class = "REGIONAL"
# ###   force_destroy = false
# ### }
# ### 
# ### # resource "google_storage_bucket_access_control" "gsbac_public_rule-03" {
# ### #   bucket = "${google_storage_bucket.gsb-03.name}"
# ### #   role = "READER"
# ### #   entity = "allAuthenticatedUsers"
# ### #   # entity = "cigaguri@gmail.com"
# 
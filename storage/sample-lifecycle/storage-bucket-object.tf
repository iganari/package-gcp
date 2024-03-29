# ============================== #
#        Test bucket 01          #
# ============================== #

resource "google_storage_bucket_object" "gsbo-pic-01-01" {
  bucket = "${google_storage_bucket.gsb-01.name}"

  name   = "azarashi-01.png"
  source = "images/irasutoya/azarashi/animal_chara_computer_azarashi.png"
}

resource "google_storage_bucket_object" "gsbo-pic-01-02" {
  bucket = "${google_storage_bucket.gsb-01.name}"

  name   = "azarashi-02.png"
  source = "images/irasutoya/azarashi/animal_chara_smartphone_azarashi.png"
}

resource "google_storage_bucket_object" "gsbo-pic-01-03" {
  bucket = "${google_storage_bucket.gsb-01.name}"

  name   = "other/azarashi-02.png"
  source = "images/irasutoya/azarashi/animal_gomafu_azarashi_baby.png"
}


# ============================== #
#        Test bucket 02          #
# ============================== #

resource "google_storage_bucket_object" "gsbo-pic-02" {
  bucket = google_storage_bucket.gsb-02.name

  count  = length(var.image-hiyoko)
  name   = "sammple/hiyoko/${element(var.image-hiyoko, count.index)}"
  source = "images/irasutoya/hiyoko/${element(var.image-hiyoko, count.index)}"
}

# ============================== #
#        Test bucket 03          #
# ============================== #

resource "google_storage_bucket_object" "gsbo-pic-03" {
  bucket = google_storage_bucket.gsb-03.name

  count  = length(var.image-penguin)
  name   = "sammple/penguin/${element(var.image-penguin, count.index)}"
  source = "images/irasutoya/penguin/${element(var.image-penguin, count.index)}"
}
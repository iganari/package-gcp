# ============================== #
#        Test bucket 01          #
# ============================== #

resource "google_storage_bucket_object" "gsbo-pic-01-01" {
  bucket = "${google_storage_bucket.gsb-01.name}"

  # name   = "animal_chara_computer_penguin.png"
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


# ===============
# Test bucket 02
# ===============


resource "google_storage_bucket_object" "gsbo-pic-02" {
  name   = "animal_chara_smartphone_penguin.png"
  source = "images/animal_chara_smartphone_penguin.png"
  bucket = "${google_storage_bucket.gsb-02.name}"
}


resource "google_storage_bucket_object" "gsbo-pic-03" {
  name   = "animal_chara_smartphone_penguin.png"
  source = "images/animal_chara_smartphone_penguin.png"
  bucket = "${google_storage_bucket.gsb-03.name}"
}

resource "google_storage_object_access_control" "gsoac-03" {
  object = "${google_storage_bucket_object.gsbo-pic-03.output_name}"
  bucket = "${google_storage_bucket.gsb-03.name}"
  role   = "READER"
  entity = "allUsers"
}
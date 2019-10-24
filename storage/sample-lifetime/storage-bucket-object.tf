resource "google_storage_bucket_object" "gsbo-pic-01" {
    name = "animal_chara_computer_penguin.png"
    source = "images/animal_chara_computer_penguin.png"
    bucket = "${google_storage_bucket.gsb-01.name}"
}


resource "google_storage_bucket_object" "gsbo-pic-02" {
    name = "animal_chara_smartphone_penguin.png"
    source = "images/animal_chara_smartphone_penguin.png"
    bucket = "${google_storage_bucket.gsb-02.name}"
}


resource "google_storage_bucket_object" "gsbo-pic-03" {
    name = "animal_chara_smartphone_penguin.png"
    source = "images/animal_chara_smartphone_penguin.png"
    bucket = "${google_storage_bucket.gsb-03.name}"
}

resource "google_storage_object_access_control" "gsoac-03" {
    object = "${google_storage_bucket_object.gsbo-pic-03.output_name}"
    bucket = "${google_storage_bucket.gsb-03.name}"
    role = "READER"
    entity = "allUsers"
}
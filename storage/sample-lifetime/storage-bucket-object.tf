resource "google_storage_bucket_object" "gsbo-pic-01" {
    name = "animal_chara_computer_penguin.png"
    source = "images/animal_chara_computer_penguin.png"
    bucket = "${google_storage_bucket.gsb.name}"
}

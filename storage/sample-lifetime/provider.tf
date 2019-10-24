provider "google" {
    project = "${terraform.workspace}"
    credentials = "${file("service_account.json")}"
    # region
}
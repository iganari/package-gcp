provider "google" {
    project = "${lookup(var.common, "project")}"
    # region
}
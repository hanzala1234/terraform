provider "google" {
  project = "client-gcp"
  region  = "us-central1"
  zone    = "us-central1-c"
  credentials= "${file("./gcloud-sa.json")}"
}
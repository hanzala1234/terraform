provider "google" {
  credentials= "${file("./gcloud-sa.json")}"
  project= "terraform-example-238617"
  zone= "europe-north1-a" 
  
}

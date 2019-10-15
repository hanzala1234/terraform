provider "google" {
  credentials= "${file("./gcloud-sa.json")}"
  project= "stunning-crane-234500"
  zone= "europe-north1-a" 
  
}

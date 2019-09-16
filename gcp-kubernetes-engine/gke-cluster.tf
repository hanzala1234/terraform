resource "google_container_cluster" "my_gke_cluster"{
	name= "my-first-gke-cluster"
        network= "default"
        initial_node_count= "3"

	node_config {
		
		machine_type= "f1-micro"
}
}




resource "google_compute_instance" "vpc_101" {
  name         = "vpc-101"
  machine_type = "${var.machine_type}"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    # A default network is created for all GCP projects
    subnetwork       = "${google_compute_subnetwork.net_101.self_link}"
    network_ip = "${google_compute_address.internal_client.address}"
    access_config = {
    }
  }
}

resource "google_compute_network" "vpc_101" {
  name                    = "vpc-101"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "net_101" {
  name          = "net-101"
  ip_cidr_range = "192.168.101.0/24"
  region  = "us-central1"
  
  network       = "${google_compute_network.vpc_101.self_link}"
  
}
resource "google_compute_firewall" "vpc_101" {
  name    = "vpc-101"
  network       = "${google_compute_network.vpc_101.self_link}"

  allow {
    protocol = "all"
  }

  source_ranges = ["0.0.0.0/0"]
 

  
}
resource "google_compute_route" "vpc_101_default" {
  name        = "vpc-101-default"
  dest_range  = "0.0.0.0/0"
  network       = "${google_compute_network.vpc_101.self_link}"
  depends_on = ["google_compute_instance.vpc_101",
    "google_compute_network.vpc_101"
    
  ]
  next_hop_ip = "192.168.101.3"
  priority    = 500
  tags=["vnet101"]
  
}
resource "google_compute_address" "internal_client" {
name = "internal-client"
address_type = "INTERNAL"
address = "192.168.101.110"
subnetwork       = "${google_compute_subnetwork.net_101.self_link}"

}



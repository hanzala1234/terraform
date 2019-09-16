

resource "google_compute_instance" "vpc_103" {
  name         = "vpc-103"
  machine_type = "f1-micro"

  boot_disk {
  
    initialize_params {
      image = "debian-cloud/debian-9"
    }
    }
  

  network_interface {
    # A default network is created for all GCP projects
    subnetwork       = "${google_compute_subnetwork.net_103.self_link}"
    network_ip = "${google_compute_address.kali.address}"
    access_config = {
         
    }
  }
}

resource "google_compute_network" "vpc_103" {
  name                    = "vpc-103"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "net_103" {
  name          = "net-103"
  ip_cidr_range = "192.168.103.0/24"
  network       = "${google_compute_network.vpc_103.self_link}"
  
}
resource "google_compute_firewall" "vpc_103" {
  name    = "vpc-103"
  network       = "${google_compute_network.vpc_103.self_link}"

  allow {
    protocol = "all"
  }

  source_ranges = ["0.0.0.0/0"]
 
}

resource "google_compute_route" "kali_default" {
  name        = "kali-default"
  dest_range  = "0.0.0.0/0"
  network       = "${google_compute_network.vpc_103.self_link}"
  depends_on = ["google_compute_instance.vpc_103",
    "google_compute_network.vpc_103"
    
  ]
  next_hop_ip = "192.168.103.2"
  priority    = 500
  tags=["kali"]
  
}
resource "google_compute_address" "kali" {
name = "kali"
address_type = "INTERNAL"
address = "192.168.103.150"
subnetwork       = "${google_compute_subnetwork.net_103.self_link}"

}

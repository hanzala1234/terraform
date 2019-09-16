

resource "google_compute_instance" "vpc_102" {
  name         = "vpc-102"
  machine_type = "${var.machine_type}"

  boot_disk {
    initialize_params {
    image = "debian-cloud/debian-9"
    
    }
  }

  network_interface {
    # A default network is created for all GCP projects
    subnetwork       = "${google_compute_subnetwork.net_102.self_link}"
    network_ip = "${google_compute_address.jump_server.address}"
    access_config = {
    }
  }
}

resource "google_compute_network" "vpc_102" {
  name                    = "vpc-102"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "net_102" {
  name          = "net-102"
  ip_cidr_range = "192.168.102.0/24"
  network       = "${google_compute_network.vpc_102.self_link}"
  
}
resource "google_compute_firewall" "vpc_102" {
  name    = "vpc-102"
  network       = "${google_compute_network.vpc_102.self_link}"

  allow {
    protocol = "all"
  }

  source_ranges = ["0.0.0.0/0"]
 

  
}
resource "google_compute_route" "vpc_102__default" {
  name        = "vpc-102-default"
  dest_range  = "0.0.0.0/0"
  network       = "${google_compute_network.vpc_102.self_link}"
  depends_on = ["google_compute_instance.vpc_102",
    "google_compute_network.vpc_102"
    
  ]
  next_hop_ip = "192.168.102.2"
  priority    = 500
  
  
}
resource "google_compute_address" "jump_server" {
name = "jump-server"
address_type = "INTERNAL"
address = "192.168.102.103"
subnetwork       = "${google_compute_subnetwork.net_102.self_link}"

}


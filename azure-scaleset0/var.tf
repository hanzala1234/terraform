variable "application_port" {
   description = "The port that you want to expose to the external load balancer"
   default     = 22
}

variable "admin_user" {
   description = "User name to use as the admin account on the VMs that will be part of the VM Scale Set"
   default     = "rxadmin"
}


variable "location"{
default = "North Central US"
}

variable "tags" {
 description = "A map of the tags to use for the resources that are deployed"
 type        = "map"

 default = {
   environment = "production"
 }
}

variable "resource_group_name" {
 
 description = "The name of the resource group in which the resources will be created"
 default     = "myResourceGroup"
}
variable "chef_provision" {
  description = "Configuration details for chef server"
   default = {
       server_url = "https://demo-chef-automate.northcentralus.cloudapp.azure.com/organizations/default"
       user_name = "bunty"
       user_key_path = "./chef-repo/.chef/bunty.pem"
       recreate_client = true
}
}

resource "azurerm_lb" "vmss" {
 name                = "vmss-lb"
 location            = "${var.location}"
 resource_group_name = "${azurerm_resource_group.vmss.name}"

 frontend_ip_configuration {
   name                 = "PublicIPAddress"
   public_ip_address_id = "${azurerm_public_ip.vmss.id}"
 }

 tags = "${var.tags}"
}

resource "azurerm_lb_backend_address_pool" "bpepool" {
 resource_group_name = "${azurerm_resource_group.vmss.name}"
 loadbalancer_id     = "${azurerm_lb.vmss.id}"
 name                = "BackEndAddressPool"
}

resource "azurerm_lb_probe" "vmss" {
 resource_group_name = "${azurerm_resource_group.vmss.name}"
 loadbalancer_id     = "${azurerm_lb.vmss.id}"
 name                = "ssh-running-probe"
 port                = "${var.application_port}"
}

resource "azurerm_lb_rule" "lbnatrule" {
   resource_group_name            = "${azurerm_resource_group.vmss.name}"
   loadbalancer_id                = "${azurerm_lb.vmss.id}"
   name                           = "http"
   protocol                       = "Tcp"
   frontend_port                  = "${var.application_port}"
   backend_port                   = "${var.application_port}"
   backend_address_pool_id        = "${azurerm_lb_backend_address_pool.bpepool.id}"
   frontend_ip_configuration_name = "PublicIPAddress"
   probe_id                       = "${azurerm_lb_probe.vmss.id}"
}

resource "azurerm_virtual_machine_scale_set" "vmss" {
 name                = "vmscaleset"
 location            = "${var.location}"
 resource_group_name = "${azurerm_resource_group.vmss.name}"
 upgrade_policy_mode = "Manual"

 sku {
   name     = "Standard_DS1_v2"
   tier     = "Standard"
   capacity = 3
 }

 provisioner "chef" {
  version     = "14.12.9"
  server_url = "${var.chef_provision.["server_url"]}"
  user_name = "${var.chef_provision.["user_name"]}"
  user_key = "${file(var.chef_provision.["user_key_path"])}"
  node_name = "Standard_DS1_v2-${count.index}"
  run_list = ["recipe[baseline-infra-install]"]
  recreate_client = "${var.chef_provision.["recreate_client"]}"
  on_failure = "continue"
  ssl_verify_mode = ":verify_none"
  connection {
       host = "${element(azurerm_public_ip.vmss.*.ip_address, count.index)}"
       type = "ssh"
       user = "rxadmin"
       password = "${data.azurerm_key_vault_secret.serveradminpwd.value}"
}
}



 storage_profile_image_reference {
   publisher = "Canonical"
   offer     = "UbuntuServer"
   sku       = "16.04-LTS"
   version   = "latest"
 }

 storage_profile_os_disk {
   name              = ""
   caching           = "ReadWrite"
   create_option     = "FromImage"
   managed_disk_type = "Standard_LRS"
 }

 storage_profile_data_disk {
   lun          = 0
   caching        = "ReadWrite"
   create_option  = "Empty"
   disk_size_gb   = 10
 }

 os_profile {
   computer_name_prefix = "vm-node"
   admin_username       = "${var.admin_user}"
   admin_password       = "${data.azurerm_key_vault_secret.serveradminpwd.value}"
   custom_data          = "${file("web.conf")}"
 }

 os_profile_linux_config {
   disable_password_authentication = false
 }

 network_profile {
   name    = "terraformnetworkprofile"
   primary = true

   ip_configuration {
     name                                   = "IPConfiguration"
     subnet_id                              = "${azurerm_subnet.vmss.id}"
     load_balancer_backend_address_pool_ids = ["${azurerm_lb_backend_address_pool.bpepool.id}"]
     primary = true
   }
 }

 tags = "${var.tags}"
}

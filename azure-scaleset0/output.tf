 output "vmss_host_name" {
     value = "${azurerm_public_ip.vmss.fqdn}"
 }
 output "vmss_public_ip" {
    value= "${azurerm_public_ip.vmss.ip_address}"


}

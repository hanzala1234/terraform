data "azurerm_key_vault" "keyvault" {

  name = "terraform-demo-kv"

  resource_group_name = "vault-rp-demo"

  
}

data "azurerm_key_vault_secret" "serveradminpwd" {

  name = "serveradminpwd"

  key_vault_id = "${data.azurerm_key_vault.keyvault.id}"

}



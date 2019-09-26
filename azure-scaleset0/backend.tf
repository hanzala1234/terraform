terraform {

  backend "azurerm" {

    storage_account_name = "tfsstatestorageaccount1"

    container_name       = "tfstate"

	key                  = "terraform.tfstate"

    access_key                  = "/dummy-access-key"

  }

}

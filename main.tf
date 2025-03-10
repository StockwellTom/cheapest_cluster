provider "azurerm" {
  features {}
  subscription_id= "b133cf1b-9061-473a-a041-99c71f10c773"
  resource_provider_registrations = "none"
}

resource "azurerm_resource_group" "main_cluster" {
  name     = "main_cluster"
  location = "West Europe"
}
provider "azurerm" {
  features {}
  subscription_id= "b133cf1b-9061-473a-a041-99c71f10c773"
  resource_provider_registrations = "none"
}

resource "azurerm_resource_group" "main_cluster" {
  name     = "main_cluster"
  location = "West Europe"
}

resource "azurerm_virtual_network" "cluster_vnet" {
  name                = "cluster_vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main_cluster.location
  resource_group_name = azurerm_resource_group.main_cluster.name
}

resource "azurerm_subnet" "cluster_subnet" {
  name                 = "cluster_subnet"
  resource_group_name  = azurerm_resource_group.main_cluster.name
  virtual_network_name = azurerm_virtual_network.cluster_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_interface" "cluster_nic" {
  name                = "cluster_nic"
  location            = azurerm_resource_group.main_cluster.location
  resource_group_name = azurerm_resource_group.main_cluster.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.cluster_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "cluster_vm" {
  name                = "cluster_vm"
  resource_group_name = azurerm_resource_group.main_cluster.name
  location            = azurerm_resource_group.main_cluster.location
  size                = "Standard_B2s"

  admin_username = "adminuser"
  admin_password = random_password.vm_password.result

  network_interface_ids = [
    azurerm_network_interface.cluster_nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

resource "azurerm_public_ip" "cluser_pip" {
  name                = "cluser_pip"
  location            = azurerm_resource_group.main_cluster.location
  resource_group_name = azurerm_resource_group.main_cluster.name
  allocation_method   = "Dynamic"
}

resource "azurerm_lb" "cluster_lb" {
  name                = "cluster_lb"
  location            = azurerm_resource_group.main_cluster.location
  resource_group_name = azurerm_resource_group.main_cluster.name
  sku                 = "Basic"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.cluser_pip.id
  }
}
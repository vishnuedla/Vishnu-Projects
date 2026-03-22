provider "azurerm" {

  subscription_id = "Subscription_id"
  features {}
}


resource "azurerm_resource_group" "resourcegroup_vishnu" {
    name = "terraform_vishnu"
    location = "eastus"
}

resource "azurerm_virtual_network" "example" {
  name                = "example-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.resourcegroup_vishnu.location
  resource_group_name = azurerm_resource_group.resourcegroup_vishnu.name
}

resource "azurerm_subnet" "example" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.resourcegroup_vishnu.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "networkcard" {
  name                = "vishnu_nic"
  location            = azurerm_resource_group.resourcegroup_vishnu.location
  resource_group_name = azurerm_resource_group.resourcegroup_vishnu.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "example" {
  name                = "example-machine"
  resource_group_name = azurerm_resource_group.resourcegroup_vishnu.name
  location            = azurerm_resource_group.resourcegroup_vishnu.location
  size                = "Standard_B1s"
  admin_username      = "adminuser"
  network_interface_ids = [
  azurerm_network_interface.networkcard.id
  ]
    admin_ssh_key {
    username   = "adminuser"
    public_key = file("C:/Users/Vishn/vishnu.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}




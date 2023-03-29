resource "azurerm_resource_group" "jumphost_resource_group" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "jumpbox_vnet" {
  name                = "vnet"
  resource_group_name = azurerm_resource_group.jumphost_resource_group.name
  location            = azurerm_resource_group.jumphost_resource_group.location
  address_space       = var.vnet_address_space
}

resource "azurerm_subnet" "jumpbox_subnet" {
  name                 = "subnet"
  virtual_network_name = azurerm_virtual_network.jumpbox_vnet.name
  resource_group_name  = azurerm_resource_group.jumphost_resource_group.name
  address_prefixes     = var.subnet_address_prefixes
}

module "azure_jumphost" {
  source = "./modules/azure-jumpbox"

  resource_group_name = azurerm_resource_group.jumphost_resource_group.name
  location            = azurerm_resource_group.jumphost_resource_group.location
  vm_name = var.vm_name
  vm_size = var.vm_size
  computer_name = var.computer_name

  vnet_address_space = var.vnet_address_space
  subnet_address_prefixes = var.subnet_address_prefixes

  jumpbox_subnet_id = azurerm_subnet.jumpbox_subnet.id

  disable_password_authentication = var.disable_password_authentication
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password

  # isLinux = false
}
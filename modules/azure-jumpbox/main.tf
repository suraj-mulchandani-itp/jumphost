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

resource "azurerm_public_ip" "jumpbox_public_ip" {
  name                = "public_ip"
  resource_group_name = azurerm_resource_group.jumphost_resource_group.name
  location            = azurerm_resource_group.jumphost_resource_group.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_security_group" "jumpbox_nsg" {
  name                = "jumpbox_nsg"
  resource_group_name = azurerm_resource_group.jumphost_resource_group.name
  location            = azurerm_resource_group.jumphost_resource_group.location

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "SSH-out"
    priority                   = 1001
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "jumpbox_nic" {
  name                = "jumpbox_nic"
  resource_group_name = azurerm_resource_group.jumphost_resource_group.name
  location            = azurerm_resource_group.jumphost_resource_group.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.jumpbox_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.jumpbox_public_ip.id
  }
}

resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.jumpbox_nic.id
  network_security_group_id = azurerm_network_security_group.jumpbox_nsg.id
}

resource "azurerm_linux_virtual_machine" "jumpbox_vm" {
  name                = var.vm_name
  resource_group_name = azurerm_resource_group.jumphost_resource_group.name
  location            = azurerm_resource_group.jumphost_resource_group.location
  size                = var.vm_size

  computer_name = var.computer_name

  disable_password_authentication = var.disable_password_authentication
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  network_interface_ids = [
    azurerm_network_interface.jumpbox_nic.id,
  ]

  os_disk {
    name                 = "myOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  tags = {
    "name" = "Jumpbox VM"
  }
}
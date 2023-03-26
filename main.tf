module "azure_jumphost" {
  source = "./modules/azure-jumpbox"

  # resource_group_name = var.resource_group_name
  # location            = var.location
  vm_name = var.vm_name
  vm_size = var.vm_size
  computer_name = var.computer_name

  vnet_address_space = var.vnet_address_space
  subnet_address_prefixes = var.subnet_address_prefixes

  disable_password_authentication = var.disable_password_authentication
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
}
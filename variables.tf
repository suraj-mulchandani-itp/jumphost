variable "resource_group_name" {
  type    = string
  default = "az_jumpbox_rg_01"
}

variable "location" {
  type    = string
  default = "Central India"
}

variable "vnet_address_space" {
  type    = list(any)
  default = ["10.0.0.0/16"]
}

# variable "jumpbox_subnet_id" {
#   type = string
# }

variable "subnet_address_prefixes" {
  type    = list(any)
  default = ["10.0.1.0/24"]
}

variable "vm_name" {
  type    = string
  default = "az_jumpbox_vm"
}

variable "computer_name" {
  type    = string
  default = "linuxvm"
}

variable "vm_size" {
  type = string
  default = "Standard_DS2_v2"
}

variable "disable_password_authentication" {
  type    = bool
  default = false
}

variable "admin_username" {
  type = string
}

variable "admin_password" {
  type = string
}
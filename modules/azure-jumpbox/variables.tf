variable "resource_group_name" {
  type    = string
  description = "The resource group name to be imported"
  default = "az_jumpbox_rg_01"
}

variable "location" {
  type    = string
  description = "Location of cluster, if not defined it will be read from the resource-group"
  default = "Central India"
}

variable "vnet_address_space" {
  type    = list(any)
}

variable "jumpbox_subnet_id" {
  type = string
}

variable "subnet_address_prefixes" {
  type    = list(any)
}

variable "vm_name" {
  type    = string
}

variable "computer_name" {
  type    = string
}

variable "vm_size" {
  type = string
}

variable "disable_password_authentication" {
  type    = bool
}

variable "admin_username" {
  type = string
}

variable "admin_password" {
  type = string
}

variable "isLinux" {
  type = bool
  default = true
}
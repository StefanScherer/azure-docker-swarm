# Settings

variable "account" {
  default = "swss"
}

variable "dns_prefix" {
  default = "swss"
}

variable "location" {
  default = "westeurope"
}

variable "azure_dns_suffix" {
  description = "Azure DNS suffix for the Public IP"
  default = "cloudapp.azure.com"
}

variable "admin_username" {
  default = "testadmin"
}

variable "admin_password" {
  default = "k6VDpmAzHU61qkihOXZm5X98i"
}

variable "ssh" {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC87nvCwiQHNYpCP+20Sk6VDpmAzHU61qkihOXZm5X98iGQU/lxBzFCYIlsIUzfdDZAEB8xjEuuNjR4AXBB0SWD67C6ez40keGe0xo7dYRaMRM/p4wU8WYedxU9y7KLWU3MK+6K8EtJUTqkVQ/OGzViAEfTACheJRwsCdu7LWju1XjeK/SdFijRoN8FE2UModLyUnwdgTQNc6xQZq0Qz+Yt9EpHeNI8MgezXb+lGWJ/OAoPg5uqpAyfBZwlo2r+efKmSdY/48T3gIZxkHdatTZ2qbQ7DZef/7nYz+TH957LxepdPawLWngtYBUuDbvV3bBudaKtQc2oGbvuz3YRmWNN"
}

variable "count" {
  type = "map"

  default = {
    windows_workers = "1"
    linux_workers = "1"
  }
}

variable "vm_size" {
  default = "Standard_D2_v2"
}

resource "azurerm_network_interface" "linux" {
  count                        = "${var.count["linux_workers"]}"
  name = "linux-${format("%02d", count.index + 1)}-nic"
  location = "${var.location}"
  resource_group_name = "${azurerm_resource_group.global.name}"

  ip_configuration {
    name = "testconfiguration1"
    subnet_id = "${azurerm_subnet.swarm.id}"
    public_ip_address_id          = "${element(azurerm_public_ip.linux.*.id, count.index)}"
    private_ip_address_allocation = "dynamic"
  }
}

resource "azurerm_public_ip" "linux" {
  count                        = "${var.count["linux_workers"]}"
  domain_name_label            = "${var.dns_prefix}-lin-${format("%02d", count.index + 1)}"
  idle_timeout_in_minutes      = 30
  location                     = "${var.location}"
  name                         = "linux-${format("%02d", count.index + 1)}-publicip"
  public_ip_address_allocation = "dynamic"
  resource_group_name          = "${azurerm_resource_group.global.name}"
}

resource "azurerm_storage_container" "linux" {
  container_access_type = "private"
  count                 = "${var.count["linux_workers"]}"
  name                  = "linux-${format("%02d", count.index + 1)}-storage"
  resource_group_name   = "${azurerm_resource_group.global.name}"
  storage_account_name  = "${azurerm_storage_account.global.name}"
}

resource "azurerm_virtual_machine" "linux" {
  count                        = "${var.count["linux_workers"]}"
  name = "linux-${format("%02d", count.index + 1)}-vm"
  location = "${var.location}"
  resource_group_name = "${azurerm_resource_group.global.name}"
  network_interface_ids = ["${element(azurerm_network_interface.linux.*.id, count.index)}"]
  vm_size = "${var.vm_size}"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name = "linux-${format("%02d", count.index + 1)}-osdisk"
    vhd_uri = "${azurerm_storage_account.global.primary_blob_endpoint}${element(azurerm_storage_container.linux.*.id, count.index)}/disk1.vhd"
    caching = "ReadWrite"
    create_option = "FromImage"
  }

  os_profile {
    computer_name = "lin-${format("%02d", count.index + 1)}"
    admin_username = "${var.admin_username}"
    admin_password = "${var.admin_password}"
  }

  os_profile_linux_config {
    disable_password_authentication = false

    ssh_keys {
      path     = "/home/${var.admin_username}/.ssh/authorized_keys"
      key_data = "${var.ssh}"
    }
  }

  provisioner "remote-exec" {
    connection {
      type = "ssh"
      user = "${var.admin_username}"
      password = "${var.admin_password}"
      host = "${var.dns_prefix}-lin-${format("%02d", count.index + 1)}.${var.location}.${var.azure_dns_suffix}"
    }

    inline = [
      "curl -sSL https://raw.githubusercontent.com/StefanScherer/docker-init/master/ubuntu/install-docker-ce.sh | CHANNEL=test sh",
      "sudo adduser ${var.admin_username} docker"
    ]
  }
}

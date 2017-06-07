resource "azurerm_virtual_network" "swarm" {
    name = "swarm-virtnet"
    address_space = ["10.0.0.0/16"]
    location = "${var.location}"
    resource_group_name = "${azurerm_resource_group.global.name}"
}

resource "azurerm_subnet" "swarm" {
    name = "swarm-${format("%02d", count.index + 1)}-sn"
    resource_group_name = "${azurerm_resource_group.global.name}"
    virtual_network_name = "${azurerm_virtual_network.swarm.name}"
    address_prefix = "10.0.2.0/24"
}

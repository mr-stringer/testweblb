resource "azurerm_network_security_group" "nsg" {
  name                = local.nsgName
  location            = var.location
  resource_group_name = var.rg

  dynamic "security_rule" {
    for_each = var.sec_rules
    content {
      name                       = security_rule.value["name"]
      priority                   = security_rule.value["priority"]
      direction                  = security_rule.value["direction"]
      access                     = security_rule.value["access"]
      protocol                   = security_rule.value["protocol"]
      source_port_range          = security_rule.value["source_port_range"]
      destination_port_range     = security_rule.value["destination_port_range"]
      source_address_prefix      = security_rule.value["source_address_prefix"]
      destination_address_prefix = security_rule.value["destination_address_prefix"]
    }
  }
}

#Bind each NIC to the NSG
resource "azurerm_network_interface_security_group_association" "ngs_nic" {
  count                     = var.vmCount
  network_interface_id      = element(azurerm_network_interface.nic.*.id, count.index)
  network_security_group_id = azurerm_network_security_group.nsg.id
}
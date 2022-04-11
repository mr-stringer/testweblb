#When behind a load-balancer, VMs lose access to the internet.  A natGW allows them access
# Create a public IPs
resource "azurerm_public_ip" "ngpubip" {
  name                = local.natGwPubIpName
  resource_group_name = var.rg
  location            = var.location
  sku                 = "Standard"
  allocation_method   = "Static"
}

resource "azurerm_nat_gateway" "natgw" {
  name                = local.natGwName
  location            = var.location
  resource_group_name = var.rg
  sku_name            = "Standard"

}

resource "azurerm_nat_gateway_public_ip_association" "ngw_pubip_ascs" {
  nat_gateway_id       = azurerm_nat_gateway.natgw.id
  public_ip_address_id = azurerm_public_ip.ngpubip.id
}

resource "azurerm_subnet_nat_gateway_association" "ngw_subnet_ascs" {
  nat_gateway_id = azurerm_nat_gateway.natgw.id
  subnet_id      = var.subnetId
}
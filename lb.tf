# Create a public IPs
resource "azurerm_public_ip" "lbpubip" {
    name                = local.lbPubIpName
    resource_group_name = var.rg
    location            = var.location
    sku = "Standard"
    allocation_method   = "Static"
}

resource "azurerm_lb" "lb" {
    name                = local.lbName
    resource_group_name = var.rg
    location            = var.location
    sku                 = "Standard"
    frontend_ip_configuration {
      name = local.lbFeIpCfgName
      #subnet_id                     = data.terraform_remote_state.base.outputs.subnetID
      public_ip_address_id = azurerm_public_ip.lbpubip.id
    }
}

resource "azurerm_lb_backend_address_pool" "backendPool" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "vmBackend"
}

resource "azurerm_network_interface_backend_address_pool_association" "lb_backend_pool_asc" {
    count = var.vmCount
    backend_address_pool_id = azurerm_lb_backend_address_pool.backendPool.id
    network_interface_id    = azurerm_network_interface.nic.*.id[count.index]
    ip_configuration_name   = "${local.nicIpConfName}-${count.index +1}"
    
}

resource "azurerm_lb_rule" "ssh_rule" {
  resource_group_name            = var.rg
  loadbalancer_id                = azurerm_lb.lb.id

  name                           = "ssh-rule"
  protocol                       = "Tcp"
  frontend_port                  = 22
  backend_port                   = 22
  frontend_ip_configuration_name = azurerm_lb.lb.frontend_ip_configuration[0].name
  probe_id                       = azurerm_lb_probe.probe22.id
  backend_address_pool_ids        = [azurerm_lb_backend_address_pool.backendPool.id]
  enable_tcp_reset = true
  disable_outbound_snat = true
}

resource "azurerm_lb_rule" "http_rule" {
  resource_group_name            = var.rg
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "8000-rule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 8000
  frontend_ip_configuration_name = azurerm_lb.lb.frontend_ip_configuration[0].name
  probe_id                       = azurerm_lb_probe.probe8000.id
  backend_address_pool_ids        = [azurerm_lb_backend_address_pool.backendPool.id]
  enable_tcp_reset = true
  disable_outbound_snat = true
}

resource "azurerm_lb_probe" "probe22" {
  resource_group_name = var.rg
  loadbalancer_id     = azurerm_lb.lb.id
  name                = "lb-probe-ssh"
  protocol            = "Tcp"
  interval_in_seconds = 5
  number_of_probes    = 2
  port                = 22
}

resource "azurerm_lb_probe" "probe8000" {
  resource_group_name = var.rg
  loadbalancer_id     = azurerm_lb.lb.id
  name                = "lb-probe-8000"
  protocol            = "Http"
  request_path =      "/"
  interval_in_seconds = 5
  number_of_probes    = 2
  port                = 8000
}

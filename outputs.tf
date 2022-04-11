output "lbPubIp" {
  description = "The Public IP address of the load balancer"
  value       = azurerm_public_ip.lbpubip.ip_address
}

output "vmNames" {
  description = "The names of the webservers"
  value       = azurerm_virtual_machine.vm.*.name
}
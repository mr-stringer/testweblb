data "template_file" "cloud_init" {
    template = file(var.cloudInitPath)
}

resource "azurerm_network_interface" "nic" {
    count = var.vmCount
    name = "${local.nicName}-${count.index +1}"
    resource_group_name = var.rg
    location = var.location
    ip_configuration {
        name = "${local.nicIpConfName}-${count.index +1}"
        subnet_id = var.subnetId
        private_ip_address_allocation = "Dynamic"
    }
}

resource "azurerm_virtual_machine" "vm" {
    count = var.vmCount
    name = "${local.vmName}-${count.index + 1}"
    location = var.location
    resource_group_name = var.rg
    network_interface_ids = [element(azurerm_network_interface.nic.*.id, count.index)]
    vm_size = "Standard_A1_v2" # this could be a variable, but it's only a rubbish test!
    storage_os_disk  {
        name = "${local.vmName}-osdisk${count.index + 1}"
        caching = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
    }

    # again, this could be more flexible, but it's only a test
  storage_image_reference {
    publisher = "SUSE"
    offer     = "openSUSE-Leap"
    sku       = "15-2"
    version   = "latest"
  }

  os_profile {
    admin_username = var.adminUser
    computer_name = "${local.vmName}-${count.index + 1}"
    custom_data = data.template_file.cloud_init.rendered
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/${var.adminUser}/.ssh/authorized_keys"
      key_data = var.adminUserPubKey
      }    
   }
}
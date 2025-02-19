resource "azurerm_linux_virtual_machine" "k8-master-vms" {
  name                            = "k8-master"
  location                        = azurerm_resource_group.kubernetes-demo-group.location
  resource_group_name             = azurerm_resource_group.kubernetes-demo-group.name
  size                            = var.vm_size
  disable_password_authentication = false
  admin_username                  = "azureuser"
  admin_password                  = var.vm_password
  network_interface_ids = [
    azurerm_network_interface.k8-master-nics.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = "osdisk-master"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

resource "azurerm_linux_virtual_machine" "k8-worker-vms" {
  count                           = 2
  name                            = "k8-worker-${count.index}"
  location                        = azurerm_resource_group.kubernetes-demo-group.location
  resource_group_name             = azurerm_resource_group.kubernetes-demo-group.name
  size                            = var.vm_size
  disable_password_authentication = false
  admin_username                  = "azureuser"
  admin_password                  = var.vm_password
  network_interface_ids = [
    azurerm_network_interface.k8-worker-nics[count.index].id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = "osdisk-worker${count.index}"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}
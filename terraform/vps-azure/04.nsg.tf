resource "azurerm_network_security_group" "k8-demo-nsg" {
  name                = "k8-demo-nsg"
  location            = azurerm_resource_group.kubernetes-demo-group.location
  resource_group_name = azurerm_resource_group.kubernetes-demo-group.name

  security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Production"
  }
}
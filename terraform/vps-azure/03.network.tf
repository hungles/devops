resource "azurerm_virtual_network" "tf-demo-vnet" {
  name                = "tf-demo-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.kubernetes-demo-group.location
  resource_group_name = azurerm_resource_group.kubernetes-demo-group.name
}

resource "azurerm_subnet" "k8-demo-subnet" {
  name                 = "k8-demo-subnet"
  resource_group_name  = azurerm_resource_group.kubernetes-demo-group.name
  virtual_network_name = azurerm_virtual_network.tf-demo-vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}
resource "azurerm_public_ip" "k8-master-public-ips" {
  name                = "k8-master-public-ip"
  resource_group_name = azurerm_resource_group.kubernetes-demo-group.name
  location            = azurerm_resource_group.kubernetes-demo-group.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "k8-master-nics" {
  name                = "k8-master-nic"
  location            = azurerm_resource_group.kubernetes-demo-group.location
  resource_group_name = azurerm_resource_group.kubernetes-demo-group.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.k8-demo-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.k8-master-public-ips.id
  }
}

resource "azurerm_network_interface_security_group_association" "asociation-master" {
  network_interface_id      = azurerm_network_interface.k8-master-nics.id
  network_security_group_id = azurerm_network_security_group.k8-demo-nsg.id
}


resource "azurerm_public_ip" "k8-worker-public-ips" {
  count               = 2
  name                = "k8-worker-${count.index}-public-ip"
  resource_group_name = azurerm_resource_group.kubernetes-demo-group.name
  location            = azurerm_resource_group.kubernetes-demo-group.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "k8-worker-nics" {
  count               = 2
  name                = "k8-worker-${count.index}-nic"
  location            = azurerm_resource_group.kubernetes-demo-group.location
  resource_group_name = azurerm_resource_group.kubernetes-demo-group.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.k8-demo-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.k8-worker-public-ips[count.index].id
  }
}
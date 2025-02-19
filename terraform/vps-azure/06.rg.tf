resource "azurerm_resource_group" "kubernetes-demo-group" {
  name     = "kubernetes-demo-group"
  location = var.region
}
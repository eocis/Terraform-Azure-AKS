data "azurerm_resource_group" "resource-group" {
    name = var.resource-group-set["name"]
}

data "azurerm_subscription" "subscription" {  
}
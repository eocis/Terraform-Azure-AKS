output "check-resource-group" {
    value = data.azurerm_resource_group.resource-group.name == var.resource-group-set["name"] ? format("%s was Exist", var.resource-group-set["name"]) : format("%s was Not Exist", var.resource-group-set["name"])
}
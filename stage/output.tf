output "check-resource-group" {
    value = data.azurerm_resource_group.resource-group.name == var.resource-group-set["name"] ? format("%s was Exist", var.resource-group-set["name"]) : format("%s was Not Exist", var.resource-group-set["name"])
}

output "application-gateway-public-ip" {
    value = azurerm_public_ip.public-ip.ip_address
}

output "subscription-id" {
    value = data.azurerm_subscription.subscription.subscription_id
}

output "identity-principal-id" {
    value = azurerm_user_assigned_identity.identity.principal_id
}

output "identity-armAuth-resource-id" {
    value = azurerm_user_assigned_identity.identity.id
}

output "identity-armAuth-client-id" {
    value = azurerm_user_assigned_identity.identity.client_id
}
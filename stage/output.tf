output "check-resource-group" {
    value = data.azurerm_resource_group.resource-group.name == var.resource-group-set["name"] ? format("%s was Exist", var.resource-group-set["name"]) : format("%s was Not Exist", var.resource-group-set["name"])
}

output "application-gateway-public-ip" {
    value = azurerm_public_ip.public-ip.ip_address
}

output "client_certificate" {
    value = azurerm_kubernetes_cluster.k8s.kube_config_raw
    sensitive = true
}

output "kube_config" {
    value = azurerm_kubernetes_cluster.k8s.kube_config_raw
    sensitive = true
}
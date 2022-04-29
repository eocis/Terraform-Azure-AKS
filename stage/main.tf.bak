# Define Provider
terraform {
    required_providers {
        azurerm = {
            source  = "hashicorp/azurerm"
            version = "=3.2.0"
        }
    }
}

provider "azurerm" {
    features {}
}

# Define Resource Group
resource "azurerm_resource_group" "resource-group" {
    count                           = data.azurerm_resource_group.resource-group.name == var.resource-group-set["name"] ? 0 : 1
    name                            = var.resource-group-set["name"]
    location                        = var.resource-group-set["location"]
}

# Define User Assigned Identities
resource "azurerm_user_assigned_identity" "identity" {
    name                            = var.identity-set["identity-name"]
    resource_group_name             = data.azurerm_resource_group.resource-group.name
    location                        = data.azurerm_resource_group.resource-group.location
    tags                            = var.tagging
}

# Create VNet(Virtual Network)
resource "azurerm_virtual_network" "vnet" {
    name                            = var.vnet-network-set["vnet-name"]
    resource_group_name             = data.azurerm_resource_group.resource-group.name
    location                        = data.azurerm_resource_group.resource-group.location
    address_space                   = [var.vnet-network-set["vnet-cidr"]]
    tags                            = var.tagging
}

resource "azurerm_subnet" "application-gateway-subnet" {
    name                            = var.subnet-network-set["application-gateway-subnet-name"]
    resource_group_name             = data.azurerm_resource_group.resource-group.name
    virtual_network_name            = azurerm_virtual_network.vnet.name
    address_prefixes                = [var.subnet-network-set["application-gateway-subnet-cidr"]]
}

resource "azurerm_subnet" "aks-subnet" {
    name                            = var.subnet-network-set["aks-subnet-name"]
    resource_group_name             = data.azurerm_resource_group.resource-group.name
    virtual_network_name            = azurerm_virtual_network.vnet.name
    address_prefixes                = [var.subnet-network-set["aks-subnet-cidr"]]
}

# Create Public IP
resource "azurerm_public_ip" "public-ip" {
    name                            = var.public-ip-set["name"]
    location                        = data.azurerm_resource_group.resource-group.location
    resource_group_name             = data.azurerm_resource_group.resource-group.name
    allocation_method               = var.public-ip-set["allocation-method"]
    sku                             = var.public-ip-set["sku"]
    tags                            = var.tagging
}

# Create Application Gateway
resource "azurerm_application_gateway" "application-gateway" {
    name                            = var.application-gateway-set["application-gateway-name"]
    resource_group_name             = data.azurerm_resource_group.resource-group.name
    location                        = data.azurerm_resource_group.resource-group.location

    identity {
        type                        = "UserAssigned"
        identity_ids                = [azurerm_user_assigned_identity.identity.id]
    }

    sku {
        name                        = var.application-gateway-set["sku-name"]
        tier                        = var.application-gateway-set["sku-tier"]
        capacity                    = var.application-gateway-set["sku-capacity"]
    }

    ssl_certificate {
        name                        = local.ssl-name
        data                        = local.ssl-data
        password                    = var.ssl-password
    }

    gateway_ip_configuration {
        name                        = var.application-gateway-set["gateway-ip-configuration-name"]
        subnet_id                   = azurerm_subnet.application-gateway-subnet.id
    }

    frontend_port {
        name                        = var.application-gateway-set["frontend-port-name"]
        port                        = var.application-gateway-set["frontend-port"]
    }

    frontend_ip_configuration {
        name                        = var.application-gateway-set["frontend-ip-configuration-name"]
        public_ip_address_id        = azurerm_public_ip.public-ip.id
    }

    backend_address_pool {
        name                        = var.application-gateway-set["backend-address-pool-name"]
    }

    backend_http_settings {
        name                        = var.application-gateway-set["backend-http-settings-name"]
        cookie_based_affinity       = var.application-gateway-set["cookie-based-affinity"]
        path                        = var.application-gateway-set["backend-path"]
        port                        = var.application-gateway-set["backend-port"]
        protocol                    = var.application-gateway-set["backend-protocol"]
        request_timeout             = var.application-gateway-set["backend-request-timeout"]
    }

    http_listener {
        name                                = var.application-gateway-set["listener-name"]
        frontend_ip_configuration_name      = var.application-gateway-set["frontend-ip-configuration-name"]
        frontend_port_name                  = var.application-gateway-set["frontend-port-name"]
        protocol                            = var.application-gateway-set["listener-protocol"]
        ssl_certificate_name                = local.ssl-name
    }

    request_routing_rule {
        name                        = var.application-gateway-set["request-routing-rule-name"]
        rule_type                   = var.application-gateway-set["request-routing-rule-type"]
        http_listener_name          = var.application-gateway-set["listener-name"]
        backend_address_pool_name   = var.application-gateway-set["backend-address-pool-name"]
        backend_http_settings_name  = var.application-gateway-set["backend-http-settings-name"]
    }

    tags                            = var.tagging

}

# Create AKS Cluster
resource "azurerm_kubernetes_cluster" "k8s" {
    # Default RBAC Enable
    name                            = var.cluster-set["name"]
    location                        = data.azurerm_resource_group.resource-group.location
    resource_group_name             = data.azurerm_resource_group.resource-group.name
    dns_prefix                      = var.cluster-set["dns-prefix"]
    kubernetes_version              = var.cluster-set["version"]

    ingress_application_gateway {
        subnet_id                   = azurerm_subnet.application-gateway-subnet.id
    }
    network_profile {
        network_plugin              = var.cluster-set["network_plugin"]
        pod_cidr                    = var.cluster-set["pod_cidr"]
    }

    default_node_pool {
        name                        = var.cluster-set["default-nodepool-name"]
        node_count                  = var.cluster-set["default-nodepool-count"]
        vm_size                     = var.cluster-set["default-nodepool-vm-size"]
        os_disk_size_gb             = var.cluster-set["default-nodepool-vm-os-disk-size"]
        vnet_subnet_id              = azurerm_subnet.aks-subnet.id
    }
    linux_profile {
        admin_username              = var.cluster-set["default-nodepool-vm-admin-name"]
        ssh_key {
          key_data                  = local.default-nodepool-vm-admin-key
        }
    }

    depends_on                      = [azurerm_virtual_network.vnet, azurerm_application_gateway.application-gateway]
    tags                            = var.tagging
}


# Application Gateway - User Assignment

resource "azurerm_role_assignment" "role-assignment-1" {
    scope                           = azurerm_subnet.aks-subnet.id
    role_definition_name            = var.identity-set["role-assignment-1-name"]
    principal_id                    = azurerm_user_assigned_identity.identity.principal_id
    depends_on                      = [azurerm_virtual_network.vnet]
}

resource "azurerm_role_assignment" "role-assignment-2" {
    scope                           = azurerm_user_assigned_identity.identity.id
    role_definition_name            = var.identity-set["role-assignment-2-name"]
    principal_id                    = azurerm_user_assigned_identity.identity.principal_id
    depends_on                      = [azurerm_user_assigned_identity.identity]
}

resource "azurerm_role_assignment" "role-assignment-3" {
    scope                           = azurerm_application_gateway.application-gateway.id
    role_definition_name            = var.identity-set["role-assignment-3-name"]
    principal_id                    = azurerm_user_assigned_identity.identity.principal_id
    depends_on                      = [azurerm_user_assigned_identity.identity, azurerm_application_gateway.application-gateway]
}

resource "azurerm_role_assignment" "role-assignment-4" {
    scope                           = data.azurerm_resource_group.resource-group.id
    role_definition_name            = var.identity-set["role-assignment-4-name"]
    principal_id                    = azurerm_user_assigned_identity.identity.principal_id
    depends_on                      = [azurerm_user_assigned_identity.identity, azurerm_application_gateway.application-gateway]
}
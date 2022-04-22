variable "resource-group-set" {
    type                        = map(string)
    default                     = {
        "name"                  = "Cloud_MSA-Dev-Test"
        "location"              = "Korea Central"
    }
}

variable "identity-set" {
    type                            = map(string)
    default                         = {
        "identity-name"             = "MSA-AKS-identity-id"
        "role-assignment-1-name"    = "Network Contributor"
        "role-assignment-2-name"    = "Managed Identity Operator"
        "role-assignment-3-name"    = "Contributor"
        "role-assignment-4-name"    = "Reader"
    }
}

variable "vnet-network-set" {
    type                                = map(string)
    default                             = {
        "vnet-name"                     = "MSA-AKS-cluster-vnet"
        "vnet-cidr"                     = "172.0.0.0/16"
    }
}

variable "subnet-network-set" {
    type                                    = map(string)
    default                                 = {
        "application-gateway-subnet-name"   = "MSA-AKS-cluster-subnet"
        "application-gateway-subnet-cidr"   = "172.0.0.0/24"
        "aks-subnet-name"                   = "MSA-aks-subnet"
        "aks-subnet-cidr"                   = "172.0.10.0/24"
    }
}

variable "public-ip-set" {
    type                                = map(string)
    default                             = {
        "name"                          = "MSA-AKS-public-ip"
        "allocation-method"             = "Static"
        "sku"                           = "Standard"
    }
  
}

variable "application-gateway-set" {
    type                                    = map(string)
    default                                 = {
        "application-gateway-name"          = "MSA-AKS-application-gateway"
        "sku-name"                          = "Standard_v2"
        "sku-tier"                          = "Standard_v2"
        "sku-capacity"                      = "2"
        "gateway-ip-configuration-name"     = "MSA-AKS-gateway-ip-configuration-name"
        "frontend-port-name"                = "httpsPort"
        "frontend-port"                     = "443"
        "frontend-ip-configuration-name"    = "MSA-AKS-frontend-ip-configuration-name"
        "backend-address-pool-name"         = "MSA-AKS-backend-address-pool-name"
        "backend-http-settings-name"        = "MSA-AKS-backend-http-settings-name"
        "cookie-based-affinity"             = "Disabled"
        "backend-path"                      = "/"
        "backend-port"                      = "80"
        "backend-protocol"                  = "Http"
        "backend-request-timeout"           = "60"
        "listener-name"                     = "MSA-AKS-application-gateway-listener"
        "listener-protocol"                 = "Https"
        "request-routing-rule-name"         = "MSA-AKS-request-routing-rule"
        "request-routing-rule-type"         = "Basic"
    }
}

variable "cluster-set" {
    type                                    = map(string)
    default                                 = {
        "name"                              = "MSA-AKS-cluster"
        "version"                           = "1.21"
        "dns-prefix"                        = "MSA-k8s-dns-prefix" 
        "identity"                          = "SystemAssigned"
        "network_plugin"                    = "kubenet"
        "pod_cidr"                          = "100.0.0.0/16"
        "default-nodepool-name"             = "default"
        "default-nodepool-count"            = "2"
        "default-nodepool-vm-size"          = "Standard_D3_v2"
        "default-nodepool-vm-os-disk-size"  = "40"                  # Default GB
        "default-nodepool-vm-admin-name"    = "vmadmin"
    }
}


variable "tagging" {
    type                                = map(string)
    default                             = {
        "Create by"                     = "kmpark"
        "terraform"                     = "true"
    }
}

variable "ssl-password" {
    sensitive = true
}
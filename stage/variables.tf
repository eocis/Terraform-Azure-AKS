variable "resource-group-set" {
    type                        = map(string)
    default                     = {
        "name"                  = "Cloud_MSA-Dev-Test"
        "location"              = "Korea Central"
    }
}

variable "identity-name" {
    type                        = string
    default                     = "kmpark"
  
}

variable "vnet-network-set" {
    type                                = map(string)
    default                             = {
        "vnet-name"                     = "MSA-cluster-vnet"
        "vnet-cidr"                     = "192.168.0.0/16"
        "subnet-name"                   = "MSA-cluster-subnet"
        "subnet-cidr"                   = "192.168.0.0/24"
    }
}

variable "subnet-network-set" {
    type                                = map(string)
    default                             = {
        "subnet-name"                   = "MSA-cluster-subnet"
        "subnet-cidr"                   = "192.168.0.0/24"
    }
}

variable "public-ip-set" {
    type                                = map(string)
    default                             = {
        "name"                          = "MSA-public-ip"
        "allocation-method"             = "Static"
        "sku"                           = "Standard"
    }
  
}

variable "application-gateway-set" {
    type                                    = map(string)
    default                                 = {
        "application-gateway-name"          = "MSA-application-gateway"
        "sku-name"                          = "Standard_v2"
        "sku-tier"                          = "Standard_v2"
        "sku-capacity"                      = "2"
        "gateway-ip-configuration-name"     = "MSA-gateway-ip-configuration-name"
        "frontend-port-name"                = "httpsPort"
        "frontend-port"                     = "443"
        "frontend-ip-configuration-name"    = "MSA-frontend-ip-configuration-name"
        "backend-address-pool-name"         = "MSA-backend-address-pool-name"
        "backend-http-settings-name"        = "MSA-backend-http-settings-name"
        "cookie-based-affinity"             = "Disabled"
        "backend-path"                      = "/"
        "backend-port"                      = "80"
        "backend-protocol"                  = "Http"
        "backend-request-timeout"           = "60"
        "listener-name"                     = "MSA-application-gateway-listener"
        "listener-protocol"                 = "Https"
        "request-routing-rule-name"         = "MSA-request-routing-rule"
        "request-routing-rule-type"         = "Basic"
    }
}

variable "cluster-set" {
    type                                = map(string)
    default                             = {
        "name"                          = "MSA-cluster"
        "version"                       = "1.21"
        "dns-prefix"                    = "MSA-k8s-dns-prefix" 
        "identity"                      = "SystemAssigned"
        "network_plugin"                = "kubenet"
        "pod_cidr"                      = "1.0.0.0/16"
        "default-nodepool-name"         = "default"
        "default-nodepool-count"        = "2"
        "default-nodepool-vm-size"     = "Standard_B2s"
    }
}


variable "tagging" {
    type                        = map(string)
    default                     = {
        "Create by" = "kmpark"
        "terraform" = "true"
    }
}
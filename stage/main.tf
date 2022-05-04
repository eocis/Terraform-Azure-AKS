provider "azurerm" {
  features {}
}

# Define Resource Group
resource "azurerm_resource_group" "resource-group" {
    count                           = data.azurerm_resource_group.resource-group.name == var.resource-group-set["name"] ? 0 : 1
    name                            = var.resource-group-set["name"]
    location                        = var.resource-group-set["location"]
}

module "network" {
  source              = "Azure/network/azurerm"
  resource_group_name = data.azurerm_resource_group.resource-group.name
  address_space       = var.vnet-network-set["vnet-cidr"]
  subnet_prefixes     = [var.subnet-network-set["subnet-cidr"]]
  subnet_names        = [var.subnet-network-set["subnet-name"]]
  depends_on          = [data.azurerm_resource_group.resource-group]
}


module "aks" {
  source                           = "Azure/aks/azurerm"
  resource_group_name              = data.azurerm_resource_group.resource-group.name
  # 아래 정보를 입력하지 않으면 자동으로 생성됩니다.
  # client_id                        = "your-service-principal-client-appid"
  # client_secret                    = "your-service-principal-client-password"
  kubernetes_version               = var.cluster-set["version"]
  orchestrator_version             = var.cluster-set["version"]
  prefix                           = var.cluster-set["dns-prefix"]
  cluster_name                     = var.cluster-set["name"]
  network_plugin                   = var.cluster-set["network-plugin"]
  vnet_subnet_id                   = module.network.vnet_subnets[0]
  os_disk_size_gb                  = var.cluster-set["default-nodepool-vm-os-disk-size"]
  sku_tier                         = "Paid" # defaults to Free
  enable_role_based_access_control = true
  # rbac_aad_admin_group_object_ids  = [data.azuread_group.aks_cluster_admins.id]
  rbac_aad_managed                 = true
  private_cluster_enabled          = false # default value
  enable_http_application_routing  = true
  enable_azure_policy              = true
  enable_auto_scaling              = true
  enable_host_encryption           = false
  agents_min_count                 = 2
  agents_max_count                 = 4
  agents_count                     = null # Please set `agents_count` `null` while `enable_auto_scaling` is `true` to avoid possible `agents_count` changes.
  agents_max_pods                  = 100
  agents_pool_name                 = "exnodepool"
  agents_availability_zones        = ["1", "2"]
  agents_type                      = "VirtualMachineScaleSets"
  enable_log_analytics_workspace = false

  agents_labels = {
    "nodepool" : "defaultnodepool"
  }

  agents_tags = {
    "Agent" : "defaultnodepoolagent"
  }

  enable_ingress_application_gateway = true
  ingress_application_gateway_name = var.application-gateway-set["application-gateway-name"]
  ingress_application_gateway_subnet_cidr = var.application-gateway-set["subnet-cidr"]

  network_policy                 = "azure"
  net_profile_dns_service_ip     = "10.0.0.10"
  net_profile_docker_bridge_cidr = "170.10.0.1/16"
  net_profile_service_cidr       = "10.0.0.0/16"

  depends_on = [module.network]
}
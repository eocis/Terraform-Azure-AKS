> ## 현재 작업 중인 코드로 정상 작동하지 않을 수 있습니다.

---


> ### Begin

https://docs.microsoft.com/ko-kr/azure/developer/terraform/create-k8s-cluster-with-aks-applicationgateway-ingress

Key vault를 사용한 인증서 배포는 이 글에서 진행하지 않습니다.

<br>

> ### AKS Kubeconfig 가져오는 방법

```
az aks get-credentials --name MSA-cluster --resource-group Cloud_MSA-Dev-Test 
```

<br>

> ### Terraform Secret Variables 설정

```terraform
+ ssl_certificate {
    # At least one attribute in this block is (or was) sensitive,
    # so its contents will not be displayed.
}
```

<br>

> ## 빌드 과정

1. Resource Group 정의
2. VNet 생성
3. K8S Cluster 및 NodePool 생성


> ## 모듈 설정  

Container Insight 및 Log Analytics를 비활성화 방법. (모듈 코드수정)

방법

.terraform > modules > variables.tf > 77줄 enable_log_analytics_workspace default 값 false 설정

> ## 주의사항

- 모듈 사용시 클러스터 생성중 인터넷 연결이 끊어지고 다시 코드를 실행했을때 생기는 오류이다.

---

```
│ Error: A resource with the ID "/subscriptions/---------------------------/resourceGroups/Cloud_MSA-Dev-Test/providers/Microsoft.ContainerService/managedClusters/MSA-AKS-cluster" already exists - to be managed via Terraform this resource needs to be imported into the State. Please see the resource documentation for "azurerm_kubernetes_cluster" for more information.
│ 
│   with module.aks.azurerm_kubernetes_cluster.main,
│   on .terraform/modules/aks/main.tf line 10, in resource "azurerm_kubernetes_cluster" "main":
│   10: resource "azurerm_kubernetes_cluster" "main" {
```

```

│ Error: deleting Subnet: (Name "MSA-AKS-cluster-subnet" / Virtual Network Name "acctvnet" / Resource Group "Cloud_MSA-Dev-Test"): network.SubnetsClient#Delete: Failure sending request: StatusCode=400 -- Original Error: Code="InUseSubnetCannotBeDeleted" Message="Subnet MSA-AKS-cluster-subnet is in use by /subscriptions/3eae77dc-9aad-4a0b-8593-21841bd2cf46/resourceGroups/MC_Cloud_MSA-Dev-Test_MSA-AKS-cluster_koreacentral/providers/Microsoft.Network/networkInterfaces/kube-apiserver.nic.ffe8b248-3b4f-4a47-9e3d-5f0919a1c0ea/ipConfigurations/privateEndpointIpConfig.aeb55b59-2dfb-476e-baba-ced9fac27325 and cannot be deleted. In order to delete the subnet, delete all the resources within the subnet. See aka.ms/deletesubnet." Details=[]
│ 
```
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

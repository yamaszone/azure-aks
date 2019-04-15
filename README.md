# Azure AKS Deployment
PoC on AKS cluster deployment using Terraform

## Pre-requisite
- [Client ID and Client Secret for Azure Service Principal for AKS](https://docs.microsoft.com/en-us/azure/aks/kubernetes-service-principal)
- Terraform `v0.11.13`
- Azure CLI `v2.0.x`
- `kubectl` if not installed already
  - See `az aks install-cli -h`

## Quickstart
- Checkout the repo
- Log into Azure
  - `az login`
- From project root, run the following:
  - `terraform init`
  - `terraform plan`
  - `terraform apply`
    - Deploys an Azure vNet and a 2 node AKS clusters using [Azure-CNI](https://docs.microsoft.com/en-us/azure/aks/configure-azure-cni)
- Connect to AKS
  - `terraform output kube_config > ~/.kube/config` or `az aks get-credentials -g <resource-group> -n <aks-cluster-name>`
    - `kubectl get nodes` # Verify 2 nodes deployed via Terraform

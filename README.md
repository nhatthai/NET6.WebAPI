# NET6.WebAPI
.NET6 WebAPI sample using Github Actions for deployments to Azure Kubernetes Service

### Requirements
+ Install Docker & DockerCompose
+ Minikube or Kubernetes cluster (see below if needed)
+ Install azure cli
+ Install Kubectl

### Usage
+ Using docker-compose
```
docker-compose up
```

+ Azure Login
```
az login
```

+ Create group in Azure
```
az group create --name LearnGithubAction --location SoutheastAsia
```

+ Create ACR
```
az acr create --resource-group LearnGithubAction --name learndeployments --sku Basic
```

Required: docker start on your machine
```
az acr login --name learndeployments
```

```
az ad sp create-for-rbac --name "dotnet6web" --role contributor --scopes /subscriptions/<SUBSCRIPTION_ID>/resourceGroups/<RESOURCE_GROUP> --sdk-auth

```
Copy and paste into the github repository 


+ [Create container registry](https://docs.microsoft.com/en-us/azure/container-registry/container-registry-auth-service-principal)
```
#!/bin/bash
# This script requires Azure CLI version 2.25.0 or later. Check version with `az --version`.

# Modify for your environment.
# ACR_NAME: The name of your Azure Container Registry
# SERVICE_PRINCIPAL_NAME: Must be unique within your AD tenant
ACR_NAME=learndeployments
SERVICE_PRINCIPAL_NAME=PrincipalLearnGithubActions

# Obtain the full registry ID
ACR_REGISTRY_ID=$(az acr show --name $ACR_NAME --query "id" --output tsv)
# echo $registryId

# Create the service principal with rights scoped to the registry.
# Default permissions are for docker pull access. Modify the '--role'
# argument value as desired:
# acrpull:     pull only
# acrpush:     push and pull
# owner:       push, pull, and assign roles
PASSWORD=$(az ad sp create-for-rbac --name $SERVICE_PRINCIPAL_NAME --scopes $ACR_REGISTRY_ID --role acrpull --query "password" --output tsv)
USER_NAME=$(az ad sp list --display-name $SERVICE_PRINCIPAL_NAME --query "[].appId" --output tsv)

# Output the service principal's credentials; use these in your services and
# applications to authenticate to the container registry.
echo "Service principal ID: $USER_NAME"
echo "Service principal password: $PASSWORD"
```

PASSWORD=$(az ad sp create-for-rbac --name $SERVICE_PRINCIPAL_NAME --scopes $ACR_REGISTRY_ID --role acrpush --query "password" --output tsv)
### References
+ [Install Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-macos)
+ [AKS Github Actions](https://docs.microsoft.com/en-us/azure/aks/kubernetes-action?tabs=userlevel)
+ [KubeLab Github Actions](https://azure.github.io/kube-labs/1-github-actions.html#_1-create-a-deployment-pipeline)
+ [AKS deployment with github actions](https://docs.microsoft.com/en-us/learn/modules/aks-deployment-pipeline-github-actions/)
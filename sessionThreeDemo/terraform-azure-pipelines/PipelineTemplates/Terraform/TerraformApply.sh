#!/bin/bash
backendResourceGroupName=$1
backendStorageAccountName=$2
backendContainerName=$3

ls -Flah

ARM_SUBSCRIPTION_ID=$(az account show --query id --out tsv)
export ARM_CLIENT_ID=$servicePrincipalId
export ARM_CLIENT_SECRET=$servicePrincipalKey
export ARM_SUBSCRIPTION_ID=$ARM_SUBSCRIPTION_ID
export ARM_TENANT_ID=$tenantId

currentWorkingDirectory=$(basename "$PWD")

echo "current working directory $currentWorkingDirectory"

terraform apply -input=false -auto-approve \
    -var "backend_resource_group_name=$backendResourceGroupName" \
    -var "backend_storage_account_name=$backendStorageAccountName" \
    -var "backend_container_name=$backendContainerName"


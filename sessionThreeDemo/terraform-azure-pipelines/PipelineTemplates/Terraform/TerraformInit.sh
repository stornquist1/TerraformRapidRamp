#!/bin/bash
backendResourceGroupName=$1
backendStorageAccountName=$2
backendContainerName=$3

pwd 
ls -Flah

currentWorkingDirectory=$(basename "$PWD")

ARM_SUBSCRIPTION_ID=$(az account show --query id --out tsv)

terraform init -upgrade -input=false \
-backend-config="subscription_id=$ARM_SUBSCRIPTION_ID" \
-backend-config="tenant_id=$tenantId" \
-backend-config="client_id=$servicePrincipalId" \
-backend-config="client_secret=$servicePrincipalKey" \
-backend-config="resource_group_name=$backendResourceGroupName" \
-backend-config="storage_account_name=$backendStorageAccountName" \
-backend-config="container_name=$backendContainerName" \
-backend-config="key=$currentWorkingDirectory.terraform.tfstate"

#!/bin/bash

set -e

RESOURCE_GROUP="rg-terraform-backend"
LOCATION="centralindia"
STORAGE_ACCOUNT="tfstate$(date +%s | sha256sum | base64 | head -c 8 | tr '[:upper:]' '[:lower:]' | tr -dc 'a-z0-9')"
CONTAINER="tfstate"

echo "Creating resource group for Terraform state..."
az group create \
  --name $RESOURCE_GROUP \
  --location $LOCATION

echo "Creating storage account..."
az storage account create \
  --name $STORAGE_ACCOUNT \
  --resource-group $RESOURCE_GROUP \
  --location $LOCATION \
  --sku Standard_LRS \
  --kind StorageV2 \
  --encryption-services blob

echo "Creating blob container..."
az storage container create \
  --name $CONTAINER \
  --account-name $STORAGE_ACCOUNT

echo "Getting storage account key..."
ACCOUNT_KEY=$(az storage account keys list \
  --resource-group $RESOURCE_GROUP \
  --account-name $STORAGE_ACCOUNT \
  --query '[0].value' -o tsv)

echo ""
echo "=========================================="
echo "✅ Backend created successfully!"
echo "=========================================="
echo ""
echo "Save these values:"
echo "  Resource Group: $RESOURCE_GROUP"
echo "  Storage Account: $STORAGE_ACCOUNT"
echo "  Container: $CONTAINER"
echo "  Account Key: $ACCOUNT_KEY"
echo ""
echo "Set environment variable:"
echo "export ARM_ACCESS_KEY=\"$ACCOUNT_KEY\""
echo ""
echo "Then run:"
echo "cd terraform/environments/dev && terraform init"

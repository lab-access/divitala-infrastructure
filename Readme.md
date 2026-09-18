# Divitala Infrastructure - Terraform IaC

Complete production-grade infrastructure on Azure using Terraform.

## Quick Start

# Authenticate
az login
az account set --subscription "YOUR_SUBSCRIPTION_ID"

# Deploy dev environment
cd terraform/environments/dev
terraform init
terraform plan
terraform apply

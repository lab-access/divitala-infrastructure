# Divitala Infrastructure on Azure

Production-grade cloud infrastructure for Divitala Inc., built entirely with Terraform.

## Overview

This repository contains all infrastructure-as-code for Divitala's migration to Azure, including:
- Networking (Hub-Spoke topology)
- Identity & Access (Entra ID, RBAC)
- Security (Azure Policies, Key Vault)
- Compute (App Service, Container Instances)
- Database (PostgreSQL, Redis)
- Monitoring (Log Analytics, Application Insights)
- Cost Governance & Compliance

## Quick Start

### Prerequisites
- Terraform 1.5.0+
- Azure CLI 2.50.0+
- Free tier Azure subscription
- Git

### Installation


# Clone repository
git clone https://github.com/YOUR_USERNAME/divitala-infrastructure.git
cd divitala-infrastructure

# Authenticate with Azure
az login
az account set --subscription "YOUR_SUBSCRIPTION_ID"

# Deploy development environment
cd terraform/environments/dev
terraform init
terraform plan
terraform apply

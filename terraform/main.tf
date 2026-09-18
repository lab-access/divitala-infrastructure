# Divitala Infrastructure - Main Configuration
# This is the root module that orchestrates all other modules

terraform {
  # Specify Terraform version requirement
  required_version = ">= 1.15.9"

  # Specify required providers and versions
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 5.6.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.9.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6.2"
    }
  }

  # Configure remote backend for state (will be filled in by terraform init)
  backend "azurerm" {
    # These values will be provided at init time via backend-config
    # or in terraform/environments/dev/backend.tfvars
  }
}

# Configure Azure Provider
provider "azurerm" {
  features {} # keep this empty in v5.x
  # The features block is still required, but most nested options were deprecated.
  # These behaviors are controlled at the resource level (e.g., inside azurerm_key_vault or azurerm_virtual_machine resources)

  # Authentication (uses environment variables or az login context)
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
}

# Configure AzureAD Provider
provider "azuread" {
  # tenant_id = var.tenant_id
  # It is optional and syntactically valid, but optional in azuread v3.x
  # The AzureAD provider will automatically use the same authentication context as the azurerm provider if not specified.
}

# Configure Random Provider (for generating passwords, unique names)
provider "random" {}

# Get current Azure context (useful for getting your object ID)
data "azurerm_client_config" "current" {}

# ============================================================
# LOCAL VALUES - Used throughout this configuration
# ============================================================

locals {
  # Company naming
  company_name = "divitala"
  project_name = "DivitalaAzure"

  # Environment and location
  environment    = var.environment
  location       = var.location
  location_short = substr(var.location, 0, 3) # "centralindia" -> "cen"

  # Naming convention: {company}-{resource_type}-{environment}-{location_short}
  # Example: dvt-rg-dev-cen, dvt-vnet-dev-cen, dvt-kv-dev-cen
  rg_name   = "rg-${local.company_name}-${var.environment}-${local.location_short}"
  vnet_name = "vnet-hub-${var.environment}"

  # Common tags applied to all resources
  common_tags = merge(
    {
      Environment = var.environment
      Company     = local.company_name
      Project     = local.project_name
      ManagedBy   = "Terraform"
      CreatedDate = timestamp()
      CostCenter  = var.cost_center
      Owner       = var.owner_email
      Criticality = "Medium"
    },
    var.additional_tags
  )
}

# ============================================================
# MODULE CALLS
# ============================================================

# Resource Group
module "resource_group" {
  source = "./modules/resource-group"

  resource_group_name = local.rg_name
  location            = local.location
  tags                = local.common_tags
}

# Networking (VNet, Subnets, NSGs, Private DNS)
module "networking" {
  source = "./modules/networking"

  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  environment         = var.environment
  vnet_name           = local.vnet_name
  vnet_address_space  = ["10.0.0.0/16"]
  subnets             = var.subnets
  tags                = local.common_tags
  depends_on          = [module.resource_group]
}


# ============================================================
# OUTPUTS - What we built
# ============================================================

output "current_subscription" {
  description = "Current Azure subscription details"
  value = {
    subscription_id = data.azurerm_client_config.current.subscription_id
    tenant_id       = data.azurerm_client_config.current.tenant_id
    object_id       = data.azurerm_client_config.current.object_id
  }
}

output "environment_info" {
  description = "Environment configuration"
  value = {
    environment  = local.environment
    location     = local.location
    company_name = local.company_name
  }
}
# Phase 1: Foundation Infrastructure - Deployment Report

## Date Deployed
18/09/2026


## Resources Created

### Resource Group
- **Name**: rg-divitala-dev-cen
- **Location**: Central India
- **Purpose**: Container for all Divitala infrastructure

### Virtual Network (Hub)
- **Name**: vnet-hub-dev
- **Address Space**: 10.0.0.0/16
- **Purpose**: Core networking infrastructure
- **Subnets**: 6

### Subnets Created
| Name | CIDR | Purpose |
|------|------|---------|
| GatewaySubnet | 10.0.0.0/24 | VPN/ExpressRoute Gateway |
| AzureFirewallSubnet | 10.0.1.0/26 | Azure Firewall (future) |
| BastionSubnet | 10.0.2.0/26 | Azure Bastion (secure admin access) |
| ManagementSubnet | 10.0.10.0/24 | Jump boxes, deployment agents |
| DataSubnet | 10.0.20.0/24 | Databases (PostgreSQL, Redis) |
| AppSubnet | 10.0.30.0/24 | Application servers/containers |

### Network Security Groups
| NSG | Subnet | Inbound Rules |
|-----|--------|---------------|
| nsg-management | ManagementSubnet | SSH/RDP from Bastion only |
| nsg-data | DataSubnet | PostgreSQL (5432) from App only |
| nsg-app | AppSubnet | HTTP/HTTPS from Load Balancer |

### Private DNS Zones
- privatelink.database.windows.net (SQL)
- privatelink.postgres.database.azure.com (PostgreSQL)
- privatelink.blob.core.windows.net (Storage)
- privatelink.vaultcore.azure.net (Key Vault)
- privatelink.azurecr.io (Container Registry)

## Infrastructure as Code

### Files Created
- terraform/modules/resource-group/main.tf
- terraform/modules/networking/main.tf
- terraform/modules/networking/nsg.tf
- terraform/modules/networking/private-dns.tf
- terraform/main.tf
- terraform/environments/dev/terraform.tfvars
- terraform/environments/dev/backend.tfvars

### How to Modify

#### Add a new subnet:
Edit `terraform/main.tf` module call:
```hcl
module "networking" {
  ...
  subnets = {
    ...
    NewSubnet = {
      address_prefix = "10.5.0.0/24"
    }
  }
  ...
}
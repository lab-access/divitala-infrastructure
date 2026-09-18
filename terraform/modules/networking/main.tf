# Networking Module - Virtual Networks, Subnets, NSGs

# ============================================================
# VARIABLES
# ============================================================

variable "resource_group_name" {
  description = "Name of resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string
}

variable "vnet_name" {
  description = "Name of Virtual Network"
  type        = string
}

variable "vnet_address_space" {
  description = "CIDR blocks for VNet"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnets" {
  description = "Subnets to create"
  type = map(object({
    address_prefix = string
  }))
}

variable "tags" {
  description = "Tags for all resources"
  type        = map(string)
  default     = {}
}

# ============================================================
# RESOURCES
# ============================================================

# Create Virtual Network
resource "azurerm_virtual_network" "hub" {
  name                = var.vnet_name
  address_space       = var.vnet_address_space
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags

  lifecycle {
    ignore_changes = [tags["CreatedDate"]]  # Don't update timestamp on every apply
  }
}

# Create all subnets from the map
resource "azurerm_subnet" "subnets" {
  for_each = var.subnets

  name                 = each.key
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [each.value.address_prefix]

  # Allow private endpoints on this subnet
  private_endpoint_network_policies     = "Enabled"
  private_link_service_network_policies_enabled = true
}




# ============================================================
# OUTPUTS
# ============================================================

output "vnet_id" {
  description = "VNet resource ID"
  value       = azurerm_virtual_network.hub.id
}

output "vnet_name" {
  description = "VNet name"
  value       = azurerm_virtual_network.hub.name
}

output "vnet_address_space" {
  description = "VNet address space"
  value       = azurerm_virtual_network.hub.address_space
}

output "subnet_ids" {
  description = "Map of subnet names to subnet IDs"
  value = {
    for subnet_name, subnet in azurerm_subnet.subnets : subnet_name => subnet.id
  }
}

output "subnet_names" {
  description = "Map of subnet names"
  value = {
    for subnet_name, subnet in azurerm_subnet.subnets : subnet_name => subnet.name
  }
}

output "subnet_prefixes" {
  description = "Map of subnet names to address prefixes"
  value = {
    for subnet_name, subnet in azurerm_subnet.subnets : subnet_name => subnet.address_prefixes[0]
  }
}
# Resource Group Module
# This is the container for all other resources

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  
  validation {
    condition     = length(var.resource_group_name) <= 90 && can(regex("^[a-zA-Z0-9._-]*[a-zA-Z0-9]$", var.resource_group_name))
    error_message = "Resource group name must be 1-90 characters, alphanumeric with ._- allowed"
  }
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resource group"
  type        = map(string)
  default     = {}
}

# Create the Resource Group
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags

  lifecycle {
    ignore_changes = [tags["CreatedDate"]]  # Don't update timestamp on every apply
  }
}

# Outputs - what this module provides to others
output "id" {
  description = "Resource Group ID"
  value       = azurerm_resource_group.main.id
}

output "name" {
  description = "Resource Group name"
  value       = azurerm_resource_group.main.name
}

output "location" {
  description = "Resource Group location"
  value       = azurerm_resource_group.main.location
}
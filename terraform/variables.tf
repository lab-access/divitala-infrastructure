# Divitala Infrastructure - Input Variables
# These are the knobs you turn to change behavior

# ============================================================
# REQUIRED VARIABLES - Must be provided
# ============================================================

variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.subscription_id) == 36 && can(regex("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", var.subscription_id))
    error_message = "Subscription ID must be a valid GUID."
  }
}

variable "tenant_id" {
  description = "Azure tenant ID"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.tenant_id) == 36
    error_message = "Tenant ID must be a valid GUID."
  }
}

# ============================================================
# OPTIONAL VARIABLES - Have defaults
# ============================================================

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod"
  }
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "centralindia"

  validation {
    condition     = contains(["centralindia", "southindia", "koreacentral", "malaysiawest"], var.location)
    error_message = "Location must be a valid Azure region that supports free tier."
  }
}

variable "cost_center" {
  description = "Cost center code for billing"
  type        = string
  default     = "CC-2026"

  validation {
    condition     = can(regex("^CC-\\d{4}$", var.cost_center))
    error_message = "Cost center must follow format CC-YYYY"
  }
}

variable "owner_email" {
  description = "Email of infrastructure owner (for alerts)"
  type        = string
  default     = "platform@divitala.com"

  validation {
    condition     = can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", var.owner_email))
    error_message = "Owner email must be valid"
  }
}

variable "additional_tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}
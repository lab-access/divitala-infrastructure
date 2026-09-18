# Divitala Infrastructure - Root Outputs
# These are exported for use by other modules or for reference

output "common_tags" {
  description = "Common tags applied to all resources"
  value       = local.common_tags
}

output "naming_convention" {
  description = "Naming convention being used"
  value       = "Pattern: {company}-{resource_type}-{environment}-{location_short}"
}

output "environment_config" {
  description = "Current environment configuration"
  value = {
    environment   = local.environment
    location      = local.location
    location_short = local.location_short
  }
}
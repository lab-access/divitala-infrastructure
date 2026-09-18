# Development Environment - Main
# This inherits all modules from root terraform directory

terraform {
  required_version = ">= 1.5.0"
}

# All actual resource creation is in ../../main.tf
# This file is intentionally minimal (environment-specific config happens via tfvars)
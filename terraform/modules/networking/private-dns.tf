# Private DNS Zones for PaaS services

# Private DNS Zone for Azure SQL Database
resource "azurerm_private_dns_zone" "sql" {
  name                = "privatelink.database.windows.net"
  resource_group_name = var.resource_group_name

  tags = var.tags

  lifecycle {
    ignore_changes = [tags["CreatedDate"]]  # Don't update timestamp on every apply
  }
}

# Private DNS Zone for PostgreSQL
resource "azurerm_private_dns_zone" "postgres" {
  name                = "privatelink.postgres.database.azure.com"
  resource_group_name = var.resource_group_name

  tags = var.tags

  lifecycle {
    ignore_changes = [tags["CreatedDate"]]  # Don't update timestamp on every apply
  }
}

# Private DNS Zone for Storage (Blobs)
resource "azurerm_private_dns_zone" "storage_blob" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = var.resource_group_name

  tags = var.tags

  lifecycle {
    ignore_changes = [tags["CreatedDate"]]  # Don't update timestamp on every apply
  }
}

# Private DNS Zone for Key Vault
resource "azurerm_private_dns_zone" "keyvault" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = var.resource_group_name

  tags = var.tags

  lifecycle {
    ignore_changes = [tags["CreatedDate"]]  # Don't update timestamp on every apply
  }
}

# Private DNS Zone for Container Registry
resource "azurerm_private_dns_zone" "acr" {
  name                = "privatelink.azurecr.io"
  resource_group_name = var.resource_group_name

  tags = var.tags

  lifecycle {
    ignore_changes = [tags["CreatedDate"]]  # Don't update timestamp on every apply
  }
}

# Link DNS zones to VNet (so resources can resolve names)
resource "azurerm_private_dns_zone_virtual_network_link" "sql" {
  name                 = "sql-link"
  private_dns_zone_id  = azurerm_private_dns_zone.sql.id
  virtual_network_id   = azurerm_virtual_network.hub.id
  registration_enabled = false

  tags = var.tags

  lifecycle {
    ignore_changes = [tags["CreatedDate"]]  # Don't update timestamp on every apply
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "postgres" {
  name                 = "postgres-link"
  private_dns_zone_id  = azurerm_private_dns_zone.postgres.id
  virtual_network_id   = azurerm_virtual_network.hub.id
  registration_enabled = false

  tags = var.tags

  lifecycle {
    ignore_changes = [tags["CreatedDate"]]  # Don't update timestamp on every apply
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "storage_blob" {
  name                 = "storage-blob-link"
  private_dns_zone_id  = azurerm_private_dns_zone.storage_blob.id
  virtual_network_id   = azurerm_virtual_network.hub.id
  registration_enabled = false

  tags = var.tags

  lifecycle {
    ignore_changes = [tags["CreatedDate"]]  # Don't update timestamp on every apply
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "keyvault" {
  name                 = "keyvault-link"
  private_dns_zone_id  = azurerm_private_dns_zone.keyvault.id
  virtual_network_id   = azurerm_virtual_network.hub.id
  registration_enabled = false

  tags = var.tags

  lifecycle {
    ignore_changes = [tags["CreatedDate"]]  # Don't update timestamp on every apply
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "acr" {
  name                 = "acr-link"
  private_dns_zone_id  = azurerm_private_dns_zone.acr.id
  virtual_network_id   = azurerm_virtual_network.hub.id
  registration_enabled = false

  tags = var.tags

  lifecycle {
    ignore_changes = [tags["CreatedDate"]]  # Don't update timestamp on every apply
  }
}

# ============================================================
# OUTPUTS
# ============================================================

output "private_dns_zones" {
  description = "Private DNS Zone IDs"
  value = {
    sql           = azurerm_private_dns_zone.sql.id
    postgres      = azurerm_private_dns_zone.postgres.id
    storage_blob  = azurerm_private_dns_zone.storage_blob.id
    keyvault      = azurerm_private_dns_zone.keyvault.id
    acr           = azurerm_private_dns_zone.acr.id
  }
}
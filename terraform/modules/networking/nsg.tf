# Network Security Groups (NSGs) - Firewall rules

# ============================================================
# NSG FOR MANAGEMENT SUBNET
# ============================================================
# Only Bastion can SSH/RDP here

resource "azurerm_network_security_group" "management" {
  name                = "${var.vnet_name}-nsg-management"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags

  lifecycle {
    ignore_changes = [tags["CreatedDate"]]  # Don't update timestamp on every apply
  }
}

# Allow SSH from Bastion
resource "azurerm_network_security_rule" "mgmt_ssh_bastion" {
  name                        = "AllowSSH-FromBastion"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "10.0.2.0/26"  # Bastion subnet
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.management.name
}

# Allow RDP from Bastion
resource "azurerm_network_security_rule" "mgmt_rdp_bastion" {
  name                        = "AllowRDP-FromBastion"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "10.0.2.0/26"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.management.name
}

# Allow internal VNet traffic
resource "azurerm_network_security_rule" "mgmt_internal" {
  name                        = "AllowInternal-VNet"
  priority                    = 120
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.management.name
}

# Deny everything else (default-deny principle)
resource "azurerm_network_security_rule" "mgmt_deny_all" {
  name                        = "DenyAll-Inbound"
  priority                    = 4096
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.management.name
}

# ============================================================
# NSG FOR DATA SUBNET
# ============================================================
# Only App tier can access databases here

resource "azurerm_network_security_group" "data" {
  name                = "${var.vnet_name}-nsg-data"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags

  lifecycle {
    ignore_changes = [tags["CreatedDate"]]  # Don't update timestamp on every apply
  }
}

# Allow PostgreSQL from App subnet
resource "azurerm_network_security_rule" "data_postgres" {
  name                        = "AllowPostgreSQL-FromApp"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "5432"
  source_address_prefix       = "10.1.20.0/24"  # App subnet
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.data.name
}

# Allow Redis from App subnet
resource "azurerm_network_security_rule" "data_redis" {
  name                        = "AllowRedis-FromApp"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "6379"
  source_address_prefix       = "10.1.20.0/24"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.data.name
}

# Deny all other inbound
resource "azurerm_network_security_rule" "data_deny_all" {
  name                        = "DenyAll-Inbound"
  priority                    = 4096
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.data.name
}

# ============================================================
# NSG FOR APP SUBNET
# ============================================================
# Application servers - accept from load balancer, communicate internally

resource "azurerm_network_security_group" "app" {
  name                = "${var.vnet_name}-nsg-app"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

# Allow HTTP from App Gateway
resource "azurerm_network_security_rule" "app_http" {
  name                        = "AllowHTTP-FromAppGateway"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "10.1.20.0/24"  # App Gateway subnet
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.app.name
}

# Allow HTTPS from App Gateway
resource "azurerm_network_security_rule" "app_https" {
  name                        = "AllowHTTPS-FromAppGateway"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "10.1.20.0/24"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.app.name
}

# Allow app port (8080) for internal services
resource "azurerm_network_security_rule" "app_port" {
  name                        = "AllowAppPort-Internal"
  priority                    = 120
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "8080"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.app.name
}

# Allow internal VNet traffic
resource "azurerm_network_security_rule" "app_internal" {
  name                        = "AllowInternal-VNet"
  priority                    = 130
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.app.name
}

# Allow all outbound (apps need to call external APIs, pull packages)
resource "azurerm_network_security_rule" "app_outbound" {
  name                        = "AllowAll-Outbound"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.app.name
}

# ============================================================
# ASSOCIATE NSGs WITH SUBNETS
# ============================================================

resource "azurerm_subnet_network_security_group_association" "management" {
  subnet_id                 = azurerm_subnet.subnets["ManagementSubnet"].id
  network_security_group_id = azurerm_network_security_group.management.id
}

resource "azurerm_subnet_network_security_group_association" "data" {
  subnet_id                 = azurerm_subnet.subnets["DataSubnet"].id
  network_security_group_id = azurerm_network_security_group.data.id
}

resource "azurerm_subnet_network_security_group_association" "app" {
  subnet_id                 = azurerm_subnet.subnets["AppSubnet"].id
  network_security_group_id = azurerm_network_security_group.app.id
}

# ============================================================
# OUTPUTS
# ============================================================

output "nsg_ids" {
  description = "NSG IDs"
  value = {
    management = azurerm_network_security_group.management.id
    data       = azurerm_network_security_group.data.id
    app        = azurerm_network_security_group.app.id
  }
}
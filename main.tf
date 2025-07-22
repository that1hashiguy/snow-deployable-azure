terraform {
  required_providers {
    azurerm = {
      version = ">= 4.13.0"
      source  = "hashicorp/azurerm"
    }
  }

  cloud {
    organization = "hashi-fed-snow-demo-org"

    workspaces {
      name = "snow-deployable-azure"
    }
  }
  required_version = ">= 1.5.6"
}

provider "azurerm" {
  #alias = "azure-default"
  features {}
  #subscription_id = "ecf4703c-9033-4da0-b7dd-0f0c33df8dfe"
}

module "azure-modules" {
  source  = "app.terraform.io/hashi-fed-snow-demo-org/ilm/azure"
  version = "1.0.16"

  # public_ip_prefix_id = var.pip_prefix
  subnet_id = azurerm_subnet.main.id
  suffix    = "snow"
  ssh-key   = var.ssh_key
  admin_username = var.username
}

resource "azurerm_resource_group" "main" {
  name     = "snow-demo-rg"
  location = "eastus"
}

resource "azurerm_virtual_network" "main" {
  address_space       = ["10.0.0.0/24"]
  name                = "snow-demo-vnet"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "main" {
  name                 = "snow-demo-snet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [cidrsubnet("10.0.0.0/24", 4, 0)]
}
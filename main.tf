# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.65"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = "eastus2"
  tags = {
    "CostCenter"   = "D100-84IM64"
    "DMZ"          = "No"
    "DeletionDate" = "12/31/2023"
    "Department"   = "Cloud Platform"
    "Division"     = "Corp"
    "Environment"  = "Sandbox"
    "ManagedBy"    = "Ansible"
    "Owner"        = "Kevin Jakubczak | kevin.m.jakubczak@sherwin.com"
    "Program"      = "Cloud Platform"
    "Project"      = "PPM 220086"
    "SubnetID"     = "274"
  }
}

# Create a virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = "corp-datamiddlwre-platopt-kmj251-sb-001-rg-vnet"
  address_space       = ["10.156.201.208/28"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags = {
    "CostCenter"  = "D100-84IM64"
    "DMZ"         = "No"
    "Department"  = "Cloud Platform"
    "Environment" = "Sandbox"
    "ManagedBy"   = "Ansible"
    "Owner"       = "Kevin Jakubczak | kevin.m.jakubczak@sherwin.com"
    "Program"     = "Item Management"
    "Project"     = "PPM 220086"
    "Division"     = "Corp"
  }
}


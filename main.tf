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
  name     = "corp-datamiddlwre-platopt-kmj251-sb-001-rg"
  location = "eastus2"
  tags = {
    "CostCenter"   = "D100-84IM24"
    "DMZ"          = "No" 
    "DeletionDate" = "12/31/2022" 
    "Department"   = "Data and Middleware" 
    "Division"     = "Corp" 
    "Environment"  = "Sandbox" 
    "ManagedBy"    = "Ansible" 
    "Owner"        = "Kevin Jakubczak | kevin.m.jakubczak@sherwin.com" 
    "Program"      = "Item Management" 
    "Project"      = "PPM 220086" 
    "SubnetID"     = "274" 
  }
}

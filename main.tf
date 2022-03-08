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
    "ManagedBy"    = "Terraform"
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
  tags                = var.basic_tags
}

resource "azurerm_subnet" "default" {
  name                 = "default"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.156.201.208/28"]
}

resource "azurerm_route_table" "default" {
  name                          = "zscaler_test"
  location                      = azurerm_resource_group.rg.location
  resource_group_name           = azurerm_resource_group.rg.name
  disable_bgp_route_propagation = false
  tags                          = var.basic_tags

  route {
    name                   = "internet"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.156.194.5"
  }
}

resource "azurerm_subnet_route_table_association" "example" {
  subnet_id      = azurerm_subnet.default.id
  route_table_id = azurerm_route_table.default.id
}

resource "azurerm_network_interface" "default" {
  count               = 2
  name                = "default_${count.index}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.basic_tags


  ip_configuration {
    name                          = "testConfiguration"
    subnet_id                     = azurerm_subnet.default.id
    private_ip_address_allocation = "dynamic"
  }
}

resource "azurerm_managed_disk" "default" {
  count                = 2
  name                 = "datadisk_${count.index}"
  location             = azurerm_resource_group.rg.location
  resource_group_name  = azurerm_resource_group.rg.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "256"
  tags                 = var.basic_tags
}

resource "azurerm_virtual_machine" "default" {
  count                 = 2
  name                  = "kmj251-vm${count.index}"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [element(azurerm_network_interface.default.*.id, count.index)]
  vm_size               = "Standard_DS1_v2"
  tags                  = var.basic_tags

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "canonical"
    offer     = "0001-com-ubuntu-confidential-vm-focal"
    sku       = "20_04-lts-cvm"
    version   = "latest"
  }

  storage_os_disk {
    name              = "myosdisk${count.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  # Optional data disks
  storage_data_disk {
    name              = "datadisk_new_${count.index}"
    managed_disk_type = "Standard_LRS"
    create_option     = "Empty"
    lun               = 0
    disk_size_gb      = "128"
  }

  storage_data_disk {
    name            = element(azurerm_managed_disk.default.*.name, count.index)
    managed_disk_id = element(azurerm_managed_disk.default.*.id, count.index)
    create_option   = "Attach"
    lun             = 1
    disk_size_gb    = element(azurerm_managed_disk.default.*.disk_size_gb, count.index)
  }

  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}
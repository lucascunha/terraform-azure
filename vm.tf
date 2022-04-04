# Criando a interface de rede. Equivale à placa de rede que irá conectar a VM à Sub-rede
resource "azurerm_network_interface" "nic-aulainfra" {
  name                = "nic"
  location            = azurerm_resource_group.rg-aulainfra.location
  resource_group_name = azurerm_resource_group.rg-aulainfra.name

  ip_configuration {
    name                          = "nic-ip"
    subnet_id                     = azurerm_subnet.sub-aulainfra.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.ip-aulainfra.id
  }
}

# Associando a interface de rede ao "firewall" NSG
resource "azurerm_network_interface_security_group_association" "nic-nsg-aulainfra" {
  network_interface_id      = azurerm_network_interface.nic-aulainfra.id
  network_security_group_id = azurerm_network_security_group.nsg-aulainfra.id
}

# Criando uma conta de armazenamento 
resource "azurerm_storage_account" "sa-aulainfra" {
  name                     = "saaulainfra"
  resource_group_name      = azurerm_resource_group.rg-aulainfra.name
  location                 = azurerm_resource_group.rg-aulainfra.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "staging"
  }
}

# Criação da VM propriamente
resource "azurerm_linux_virtual_machine" "vm-aulainfra" {
  name                = "vm"
  resource_group_name = azurerm_resource_group.rg-aulainfra.name
  location            = azurerm_resource_group.rg-aulainfra.location
  size                = "Standard_DS1_v2"
  network_interface_ids = [
    azurerm_network_interface.nic-aulainfra.id
  ]

  admin_username      = var.user
  admin_password      = var.password
  disable_password_authentication = false
  
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  os_disk {
    name                 = "mydisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.sa-aulainfra.primary_blob_endpoint
  }
}
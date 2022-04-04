# Criação da virtual network
resource "azurerm_virtual_network" "vnet-aulainfra" {
  name                = "vnet"
  location            = azurerm_resource_group.rg-aulainfra.location
  resource_group_name = azurerm_resource_group.rg-aulainfra.name
  address_space       = ["10.0.0.0/16"]

  # tags são opicionais
  tags = {
    environment = "Production"
    turma       = "FS04"
    faculdade   = "Impacta"
    aluno       = "Lucas"
  }
}

# Criando uma subrede dentro da rede virtual
resource "azurerm_subnet" "sub-aulainfra" {
  name                 = "subnet"
  resource_group_name  = azurerm_resource_group.rg-aulainfra.name
  virtual_network_name = azurerm_virtual_network.vnet-aulainfra.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Criando o endereço IP que será usado para acessar a VM
resource "azurerm_public_ip" "ip-aulainfra" {
  name                = "publicip"
  location            = azurerm_resource_group.rg-aulainfra.location
  resource_group_name = azurerm_resource_group.rg-aulainfra.name
  allocation_method   = "Dynamic"

  tags = {
    environment = "test"
  }
}

# Criando uma variável para obter o IP publico da VM que está lá no terraform.tfstate
data "azurerm_public_ip" "ip-aulainfra-data" {
  name                = azurerm_public_ip.ip-aulainfra.name
  resource_group_name = azurerm_resource_group.rg-aulainfra.name
}

# Network Security Group equivale ao Firewall. A VM poderia ser criada sem este firewall
resource "azurerm_network_security_group" "nsg-aulainfra" {
  name                = "nsg"
  location            = azurerm_resource_group.rg-aulainfra.location
  resource_group_name = azurerm_resource_group.rg-aulainfra.name

  security_rule {
    name                       = "SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Adicionando uma nova regra no firewall para liberar a porta 80
  security_rule {
    name                       = "Web"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

    tags = {
        environment = "Production"
    }
}
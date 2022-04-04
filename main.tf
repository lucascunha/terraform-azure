# Declarando a versão e o plugin /  provedor de nuvem que iremos usar
terraform {
  required_version = ">= 0.13"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.26"
    }
  }
}

provider "azurerm" {
  features {}
}

# rg-aulainfra - Este nome existe somente dentro do escopo do terraform
# aulainfracloudterra - Este é o nome do recurso que será criado na azure
resource "azurerm_resource_group" "rg-aulainfra" {
  name     = "aulainfracloudterra"
  location = "eastus"
}

### Criação da virtual network - network.tf

### Criação da Maquina - vm.tf

### Criação dos Null Resources - deploy.tf



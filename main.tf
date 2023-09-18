# Generate random resource group name
resource "random_pet" "rg_name" {
  prefix = var.resource_group_name_prefix
}

resource "azurerm_resource_group" "rg" {
  location = var.resource_group_location
  name     = random_pet.rg_name.id
  tags = {
    "Owner" = "Alim"
    "Purpose" = "Learning"
    "Type" = "RG"
  }
}

data "azurerm_client_config" "example" {}

resource "random_pet" "azurerm_container_registry_name" {
  prefix = "acr"
}

resource "azurerm_container_registry" "demoacr" {
  name                = replace(random_pet.azurerm_container_registry_name.id, "-", "")
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Standard"  ## Use Premium ACR if required to use with Managed Identity
  admin_enabled       = true        ## Set to false if using with Managed Identity
  tags = {
    "Owner" = "Alim"
    "Purpose" = "Learning"
    "Type" = "ACR"
  }
}

resource "azurerm_role_assignment" "example" {
  scope                = azurerm_container_registry.demoacr.id
  role_definition_name = "Contributor"
  principal_id         = data.azurerm_client_config.example.object_id
}

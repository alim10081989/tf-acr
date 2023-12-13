output "admin_password" {
  value     = azurerm_container_registry.demoacr.admin_password
  sensitive = true
}

output "container_registry" {
  value = azurerm_container_registry.demoacr.login_server
}
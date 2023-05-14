output "ip_server" {
  description = "IP del servidor"
  value       = azurerm_linux_virtual_machine.vm.public_ip_address
}

/*output "client_certificate" {
  value     = azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate
  sensitive = true
}

output "kube_config" {
  value     = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive = true
}*/

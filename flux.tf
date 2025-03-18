resource "azurerm_resource_provider_registration" "kubernetes_configuration" {
  name = "Microsoft.KubernetesConfiguration"
}

resource "azurerm_kubernetes_cluster_extension" "flux_extension" {
  name           = "flux"
  cluster_id     = azurerm_kubernetes_cluster.aks_cluster.id
  extension_type = "microsoft.flux"

  depends_on = [azurerm_resource_provider_registration.kubernetes_configuration]
}

resource "azurerm_kubernetes_flux_configuration" "k8s_flux" {
  name       = "flux-system"
  cluster_id = azurerm_kubernetes_cluster.aks_cluster.id
  namespace  = "flux-system"

  git_repository {
    url             = "https://github.com/StockwellTom/cheapest_cluster"
    reference_type  = "branch"
    reference_value = "master"
    sync_interval_in_seconds = 60
    timeout_in_seconds = 120
  }

  kustomizations {
    name                      = "kustomization-2"
    path                      = "./flux/"
    sync_interval_in_seconds  = 60
    retry_interval_in_seconds = 60
  }

  scope      = "cluster"
  depends_on = [azurerm_kubernetes_cluster_extension.flux_extension]
}
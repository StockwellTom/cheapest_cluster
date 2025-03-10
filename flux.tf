resource "azurerm_kubernetes_cluster_extension" "flux" {
  name          = "flux"
  cluster_id    = azurerm_kubernetes_cluster.aks_cluster.id
  extension_type = "microsoft.flux"
}

resource "azurerm_kubernetes_flux_configuration" "k8s_flux" {
  name       = "flux-system"
  cluster_id = azurerm_kubernetes_cluster.aks_cluster.id
  namespace  = "flux-system"

  git_repository {
    url             = "https://github.com/StockwellTom/cheapest_cluster"
    reference_type  = "branch"
    reference_value = "master"
  }

  kustomizations {
    name                     = "kustomization-2"
    path                     = "./flux/sample_app2"
    sync_interval_in_seconds = 60
    retry_interval_in_seconds = 60
  }

  scope = "cluster"
  depends_on = [azurerm_kubernetes_cluster_extension.flux]
}
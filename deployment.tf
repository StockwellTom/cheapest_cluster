resource "kubernetes_namespace" "sample_namespace" {
  metadata {
    name = "sample"
  }
}

resource "kubernetes_deployment" "sample_deployment" {
  metadata {
    name = "nginx-sample"
    labels = {
      test = "nginx-sample"
    }
    annotations = {
        deployed-by = "Terraform"
    }
  }

  spec {
    replicas = 0

    selector {
      match_labels = {
        test = "nginx-sample"
      }
    }

    template {
      metadata {
        labels = {
          test = "nginx-sample"
        }
      }

      spec {
        container {
          image = "nginx:1.21.6"
          name  = "nginx-app"

          resources {
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }

          liveness_probe {
            http_get {
              path = "/"
              port = 80
            }

            initial_delay_seconds = 3
            period_seconds        = 3
          }
        }
      }
    }
  }
}
resources "kubernetes_deployment" "cashier" {
  metadata {
    name      = "cashier"
    namespace = var.kubernetes_ns
  }
}

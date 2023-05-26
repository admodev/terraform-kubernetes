resource "kubernetes_persistent_volume_v1" "mysql-volume" {
  metadata {
    name = "mysql-volume"
  }

  spec {
    capacity = {
      storage = "10Gi"
    }

    access_modes = ["ReadWriteMany"]
    persistent_volume_source {
      vsphere_volume {
        volume_path = "/var/lib/mysql"
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim_v1" "mysql-pv" {
  metadata {
    name = "mysql-pv"
  }

  spec {
    access_modes = ["ReadWriteMany"]
    resources {
      requests = {
        storage = "5Gi"
      }
    }
    volume_name = "${kubernetes_persistent_volume_v1.mysql-volume.metadata.0.name}"
  }
}

resource "kubernetes_deployment" "mysql" {
  metadata {
    name      = "mysql"
    namespace = var.kubernetes_ns
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "mysql"
      }
    }

    template {
      metadata {
        labels = {
          app = "mysql"
        }
      }

      spec {
        container {
          image = "mysql:8.0"
          name  = "mysql"
          port {
            container_port = 3306
          }
          env {
            name  = "MYSQL_ROOT_PASSWORD"
            value = "admocode"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "mysql-service" {
  metadata {
    name      = "mysql"
    namespace = var.kubernetes_ns
  }
  spec {
    selector = {
      app = "${kubernetes_deployment.mysql.spec.0.template.0.metadata.0.labels.app}"
    }
    port {
      port = 3306
    }
  }
}

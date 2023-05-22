terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_namespace" "terraform-kubernetes" {
  metadata {
    name = "terraform-kubernetes"
  }
}

module "nginx" {
  source = "./modules/nginx"

  kubernetes_ns = "${kubernetes_namespace.terraform-kubernetes.metadata.0.name}"
}

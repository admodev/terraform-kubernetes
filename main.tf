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

locals {
  kubernetes_namespace_value = "${kubernetes_namespace.terraform-kubernetes.metadata.0.name}"
}

module "nginx" {
  source = "./modules/nginx"

  kubernetes_ns = local.kubernetes_namespace_value
}

module "mysql" {
  source = "./modules/mysql"

  kubernetes_ns = local.kubernetes_namespace_value
  mysql_password = var.mysql_password
}

module "cashier" {
  source = "./modules/cashier"

  kubernetes_ns = local.kubernetes_namespace_value
}

variable "location" {
  type    = string
  default = "West US"
}

variable "cluster_rg_name" {
  type    = string
  default = "kml_rg_main-e1a2d089e4544aa9"
}

variable "prefix" {
  type    = string
  default = "demo"
}

variable "kubernetes_version" {
  type    = string
  default = "1.30.1"
}
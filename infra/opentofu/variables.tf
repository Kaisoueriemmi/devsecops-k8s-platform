variable "floci_endpoint" {
  description = "Adresse de Floci (hôte : http://localhost:4566 ; cluster : http://<IP nœud>:30566)."
  type        = string
  default     = "http://localhost:4566"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "printbox_bucket" {
  description = "Bucket des fichiers envoyés par les clients de PrintBox."
  type        = string
  default     = "printbox"
}

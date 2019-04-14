variable "client_id" {
  description = "The Client ID for the Service Principal to use for this Managed Kubernetes Cluster"
}

variable "client_secret" {
  description = "The Client Secret for the Service Principal to use for this Managed Kubernetes Cluster"
}

variable "location" {
  description = "The Azure Region in which all resources should be provisioned"
  default     = "westus"
}

variable "prefix" {
  description = "A prefix used for all resources"
}

variable "public_ssh_key_path" {
  description = "The Path at which your Public SSH Key is located. Defaults to ~/.ssh/id_rsa.pub"
  default     = "~/.ssh/id_rsa.pub"
}

output "network_plugin" {
  value = "${module.aks.network_plugin}"
}

output "service_cidr" {
  value = "${module.aks.service_cidr}"
}

output "dns_service_ip" {
  value = "${module.aks.dns_service_ip}"
}

output "docker_bridge_cidr" {
  value = "${module.aks.docker_bridge_cidr}"
}

output "cluster_username" {
  value = "${module.aks.cluster_username}"
}

output "cluster_password" {
  value = "${module.aks.cluster_password}"
}

output "kube_config" {
  value = "${module.aks.kube_config}"
}

output "master_url" {
  value = "${module.aks.host}"
}

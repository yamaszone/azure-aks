variable "prefix" {}

variable "location" {}

variable "client_id" {}

variable "client_secret" {}

variable "public_ssh_key_path" {}

resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-rg"
  location = "${var.location}"
}

resource "azurerm_route_table" "rt" {
  name                = "${var.prefix}-rt"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  # https://docs.microsoft.com/en-us/azure/virtual-network/virtual-networks-udr-overview#custom-routes
  route {
    name                   = "default"
    address_prefix         = "10.100.0.0/14"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.10.1.1"
  }
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.prefix}-vnet"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  address_space       = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "subnet" {
  name                 = "${var.prefix}-subnet"
  resource_group_name  = "${azurerm_resource_group.rg.name}"
  address_prefix       = "10.1.0.0/18"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"

  # this field is deprecated and will be removed in 2.0 - but is required until then
  route_table_id = "${azurerm_route_table.rt.id}"
}

resource "azurerm_subnet_route_table_association" "rt_assoc" {
  subnet_id      = "${azurerm_subnet.subnet.id}"
  route_table_id = "${azurerm_route_table.rt.id}"
}

resource "azurerm_kubernetes_cluster" "k8s" {
  name                = "${var.prefix}-k8s"
  location            = "${azurerm_resource_group.rg.location}"
  dns_prefix          = "${var.prefix}-k8s"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  linux_profile {
    admin_username = "adminuser"

    ssh_key {
      key_data = "${file(var.public_ssh_key_path)}"
    }
  }

  # TODO: parameterize pool metadata
  agent_pool_profile {
    #name            = "${var.prefix}agentpool"
    name            = "agentpool"
    count           = "2"
    vm_size         = "Standard_DS2_v2"
    os_type         = "Linux"
    os_disk_size_gb = 30

    # Required for advanced networking
    vnet_subnet_id = "${azurerm_subnet.subnet.id}"
  }

  service_principal {
    client_id     = "${var.client_id}"
    client_secret = "${var.client_secret}"
  }

  network_profile {
    network_plugin = "azure"
  }
}

output "subnet_id" {
  value = "${azurerm_kubernetes_cluster.k8s.agent_pool_profile.0.vnet_subnet_id}"
}

output "network_plugin" {
  value = "${azurerm_kubernetes_cluster.k8s.network_profile.0.network_plugin}"
}

output "service_cidr" {
  value = "${azurerm_kubernetes_cluster.k8s.network_profile.0.service_cidr}"
}

output "dns_service_ip" {
  value = "${azurerm_kubernetes_cluster.k8s.network_profile.0.dns_service_ip}"
}

output "docker_bridge_cidr" {
  value = "${azurerm_kubernetes_cluster.k8s.network_profile.0.docker_bridge_cidr}"
}

output "pod_cidr" {
  value = "${azurerm_kubernetes_cluster.k8s.network_profile.0.pod_cidr}"
}

output "client_key" {
  value = "${azurerm_kubernetes_cluster.k8s.kube_config.0.client_key}"
}

output "client_certificate" {
  value = "${azurerm_kubernetes_cluster.k8s.kube_config.0.client_certificate}"
}

output "cluster_ca_certificate" {
  value = "${azurerm_kubernetes_cluster.k8s.kube_config.0.cluster_ca_certificate}"
}

output "cluster_username" {
  value = "${azurerm_kubernetes_cluster.k8s.kube_config.0.username}"
}

output "cluster_password" {
  value = "${azurerm_kubernetes_cluster.k8s.kube_config.0.password}"
}

output "kube_config" {
  value = "${azurerm_kubernetes_cluster.k8s.kube_config_raw}"
}

output "host" {
  value = "${azurerm_kubernetes_cluster.k8s.kube_config.0.host}"
}

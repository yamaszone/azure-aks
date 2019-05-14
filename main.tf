provider "azurerm" {
  version = "=1.24.0"
}

module "aks" {
  source              = "modules/aks"
  client_id           = "${var.client_id}"
  client_secret       = "${var.client_secret}"
  location            = "${var.location}"
  prefix              = "${var.prefix}"
  public_ssh_key_path = "${var.public_ssh_key_path}"
  admin_username      = "adminuser"
  worker_count        = "4"
  worker_vm_type      = "Standard_DS2_v2"
  worker_vm_disk_size = "50"
}

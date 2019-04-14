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
}

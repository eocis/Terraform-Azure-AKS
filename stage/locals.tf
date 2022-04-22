locals {
  ssl-name                          = "eocis.app"
  ssl-data                          = filebase64("../ssl/eocis.app.pfx")
  default-nodepool-vm-admin-key     = file("../KP/vm.pub")
}
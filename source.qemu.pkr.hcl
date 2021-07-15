
source "qemu" "full" {
  vm_name          = "${var.name}"
  headless         = "${var.headless}"

  output_directory = "${var.output_directory}/${var.name}-qemu"

  accelerator      = "${var.accelerator}"
  boot_command     = local.boot_command
  boot_wait        = "5s"
  shutdown_command = local.shutdown_command
  
  cpus             = "${var.cpus}"
  memory           = "${var.memory}"
  disk_size        = "${var.disk_size}"
  
  iso_checksum     = local.iso_checksum
  iso_urls         = local.ios_urls
  
  ssh_username     = "${var.username}"
  ssh_password     = "${var.password}"
  ssh_timeout      = "30m"  
}

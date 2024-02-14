
source "vmware-iso" "preflight" {
  vm_name          = "${var.name}-preflight"
  headless         = "${var.headless}"
  
  guest_os_type    = "${var.guest_os_type}"

  output_directory = "${var.output_directory}/${var.name}-vmware-iso-preflight"

  boot_command     = local.boot_command
  boot_wait        = "6s"
  shutdown_command = local.shutdown_command

  iso_checksum     = local.iso_checksum
  iso_urls         = local.iso_urls

  ssh_username           = var.username
  ssh_password           = var.password
  ssh_pty                = false
	ssh_timeout            = "20m"
  ssh_handshake_attempts = 100  
  
  disk_size    = var.disk_size
  disk_type_id = var.vmware_disk_type_id
  cpus         = var.cpus
  memory       = var.memory

  http_content = {
    "/meta-data" = ""
    "/user-data" = local.cloud_config
  }
}

source "vmware-iso" "full" {
  vm_name          = var.name
  headless         = "${var.headless}"

  output_directory = "${var.output_directory}/${var.name}-vmware-iso-full"

  boot_command     = local.boot_command
  boot_wait        = "6s"
  shutdown_command = local.shutdown_command

  iso_checksum     = local.iso_checksum
  iso_urls         = local.iso_urls

  ssh_username           = var.username
  ssh_password           = var.password
  ssh_pty                = false
	ssh_timeout            = "20m"
  ssh_handshake_attempts = 100  
  
  disk_size    = var.disk_size
  disk_type_id = var.vmware_disk_type_id
  cpus         = var.cpus
  memory       = var.memory

  http_content = {
    "/meta-data" = ""
    "/user-data" = local.cloud_config
  }
}



source "vmware-iso" "preflight" {
  vm_name  = "${var.name}-preflight"
  headless = "${var.headless}"

  guest_os_type = "${local.guest_os_type}"
  firmware      = var.arch == "arm64" ? "efi" : "bios"
  
  vmx_data = var.arch == "arm64" ? {
    "virtualHW.version" = "20"
    "vhv.enable" = "TRUE"
    "usb.present" = "TRUE"
    "usb:1.present" = "TRUE"
    "usb:1.deviceType" = "hub"
    "usb:1.port" = "1"
  } : {}

  output_directory = "${var.output_directory}/${var.name}-vmware-iso-preflight"

  boot_command     = local.boot_command
  boot_wait        = "6s"
  shutdown_command = local.shutdown_command

  iso_checksum = local.iso_checksum
  iso_urls     = local.iso_urls

  ssh_username           = var.username
  ssh_password           = var.password
  ssh_port               = 2222
  ssh_pty                = false
  ssh_timeout            = "40m"
  ssh_handshake_attempts = 100

  disk_size    = var.disk_size
  disk_type_id = var.vmware_disk_type_id
  disk_adapter_type = var.arch == "arm64" ? "nvme" : "lsilogic"
  cpus         = var.cpus
  memory       = var.memory

  http_content = {
    "/meta-data" = ""
    "/user-data" = local.cloud_config
  }
}

source "vmware-iso" "full" {
  vm_name  = var.name
  headless = "${var.headless}"
  
  guest_os_type = "${local.guest_os_type}"
  firmware      = var.arch == "arm64" ? "efi" : "bios"
  
  vmx_data = var.arch == "arm64" ? {
    "virtualHW.version" = "20"
    "vhv.enable" = "TRUE"
    "usb.present" = "TRUE"
    "usb:1.present" = "TRUE"
    "usb:1.deviceType" = "hub"
    "usb:1.port" = "1"
  } : {}

  output_directory = "${var.output_directory}/${var.name}-vmware-iso-full"

  boot_command     = local.boot_command
  boot_wait        = "6s"
  shutdown_command = local.shutdown_command

  iso_checksum = local.iso_checksum
  iso_urls     = local.iso_urls

  ssh_username           = var.username
  ssh_password           = var.password
  ssh_pty                = false
  ssh_timeout            = "60m"
  ssh_handshake_attempts = 100

  disk_size    = var.disk_size
  disk_type_id = var.vmware_disk_type_id
  disk_adapter_type = var.arch == "arm64" ? "nvme" : "lsilogic"
  cpus         = var.cpus
  memory       = var.memory

  http_content = {
    "/meta-data" = ""
    "/user-data" = local.cloud_config
  }
}


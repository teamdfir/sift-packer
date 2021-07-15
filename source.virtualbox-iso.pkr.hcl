
source "virtualbox-iso" "full" {
  vm_name              = "${var.name}"
  
  output_directory     = "${var.output_directory}/${var.name}-virtualbox-iso"

  boot_command         = local.boot_command
  boot_wait            = "5s"
  shutdown_command     = local.shutdown_command

  cpus                 = "${var.cpus}"
  memory               = "${var.memory}"
  disk_size            = "${var.disk_size}"
  
  guest_additions_mode = "disable"
  guest_os_type        = "Ubuntu_64"
  hard_drive_interface = "sata"
  headless             = "${var.headless}"
  
  iso_checksum         = local.iso_checksum
  iso_urls             = local.ios_urls

  ssh_password         = "${var.password}"
  ssh_timeout          = "30m"
  ssh_username         = "${var.username}"
  vboxmanage           = [["modifyvm", "{{ .Name }}", "--graphicscontroller", "vmsvga"], ["modifyvm", "{{ .Name }}", "--audiocontroller", "ac97"]]
  
  http_content = {
    "/preseed" = local.ubuntu_desktop_preseed
  }
}

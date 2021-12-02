# Note: we don't have cpu/memory/disk/preseed content here as this using a pre-existing
# vmx file to continue a build process so none of those options are valid.

source "vmware-vmx" "full" {
  vm_name  = var.name
  headless = "${var.headless}"

  guest_os_type    = "${var.guest_os_type}"

  source_path      = "${var.output_directory}/${local.vmware_vmx_source}-preflight/${var.name}.vmx"
  output_directory = "${var.output_directory}/${var.name}"

  shutdown_command = local.shutdown_command
  
  ssh_password     = var.password
  ssh_pty          = false
  ssh_username     = var.username
  ssh_wait_timeout = "10000s"

  # Note: add remove options here for remote vsphere build
  # Docs: https://www.packer.io/docs/builders/vmware/vmx
}

source "vmware-vmx" "update" {
  vm_name  = var.name
  headless = "${var.headless}"
  
  guest_os_type    = "${var.guest_os_type}"

  source_path      = "${var.output_directory}/${var.name}-vmware-iso-full/${var.name}.vmx"
  output_directory = "${var.output_directory}/${var.name}-update"

  shutdown_command = local.shutdown_command
  
  ssh_password     = var.password
  ssh_pty          = false
  ssh_username     = var.username
  ssh_wait_timeout = "10000s"

  # Note: add remove options here for remote vsphere build
  # Docs: https://www.packer.io/docs/builders/vmware/vmx
}

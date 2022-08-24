build {
  sources = ["source.vmware-vmx.full"]

  # Stage 3 - Custom Scripts
  # This section is for scripts that are added custom to the packer build not included
  # by the template, these can be anything that needs to happen to prepare the system
  provisioner "shell" {
    execute_command = "echo '${var.password}' | sudo -S -E bash '{{ .Path }}'"
    scripts = [
      "${path.root}/custom_scripts/cast-install.sh",
    ]
  }

  provisioner "shell" {
    execute_command = "echo '${var.password}' | sudo -S -E bash '{{ .Path }}'"
    scripts = [
      "${path.root}/custom_scripts/cast-sift.sh",
    ]
  }

  # Stage X - Sysprep Scripts (Part 2)
  # Final Scripts, the last scripts that should be run.
  provisioner "shell" {
    execute_command = "echo '${var.password}' | sudo -S -E bash '{{ .Path }}'"
    scripts = [
      "${path.root}/builtin_scripts/ubuntu/clean-saltstack.sh",
      "${path.root}/builtin_scripts/virt-sysprep/sysprep-op-dhcp-client-state.sh",
      "${path.root}/builtin_scripts/virt-sysprep/sysprep-op-logfiles.sh",
      "${path.root}/builtin_scripts/virt-sysprep/sysprep-op-machine-id.sh",
      "${path.root}/builtin_scripts/virt-sysprep/sysprep-op-network.sh",
      "${path.root}/builtin_scripts/virt-sysprep/sysprep-op-package-manager-cache.sh",
      "${path.root}/builtin_scripts/virt-sysprep/sysprep-op-ssh-hostkeys.sh",
      "${path.root}/builtin_scripts/virt-sysprep/sysprep-op-tmp-files.sh",
      "${path.root}/builtin_scripts/virt-sysprep/sysprep-op-disk-space.sh",
    ]
  }

  post-processors {
    post-processor "shell-local" {
      inline = ["ovftool ${var.output_directory}/${var.name}/${var.name}.vmx ${var.output_directory}/${var.name}.ova"]
    }
  }
}

build {
  sources = ["source.vmware-vmx.update"]

  provisioner "shell" {
    # Note: sudo -S env is necessary ot pass the environment variables down to each script
    execute_command  = "echo '${var.password}' | sudo -S env {{ .Vars }} {{ .Path }}"
    environment_vars = local.script_environment_variables
    scripts = [
      "${path.root}/builtin_scripts/ubuntu/disable-aptdaily.sh",
      "${path.root}/builtin_scripts/ubuntu/system-update.sh",
    ]
  }

  provisioner "shell" {
    execute_command = "echo '${var.password}' | sudo -S -E bash '{{ .Path }}'"
    scripts = [
      "${path.root}/custom_scripts/cast-install.sh",
      "${path.root}/custom_scripts/cast-sift.sh",
      "${path.root}/custom_scripts/cast-clean.sh",
    ]
  }

  # Stage X - Sysprep Scripts (Part 2)
  # Final Scripts, the last scripts that should be run.
  provisioner "shell" {
    execute_command = "echo '${var.password}' | sudo -S -E bash '{{ .Path }}'"
    scripts = [
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
      inline = ["ovftool ${var.output_directory}/${var.name}-update/${var.name}.vmx ${var.output_directory}/${var.name}-update.ova"]
    }
  }
}

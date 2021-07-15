build {
  sources = ["source.vmware-vmx.update"]

  # Stage 4 - Saltstack
  provisioner "salt-masterless" {
    local_state_tree = "${path.root}/sift-saltstack"
    skip_bootstrap   = true
    # Uncomment this once PR () gets merged
    # execute_command  = "echo '${var.password}' | sudo -S -E"
    custom_state     = "sift.desktop"
    salt_call_args   = "--state-output=terse"
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
      inline = ["ovftool ${var.output_directory}/${var.name}-update/${var.name}.vmx ${var.output_directory}/${var.name}-update.ova"]
    }
  }
}

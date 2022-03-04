build {
  sources = ["source.amazon-ebs.full"]

  # Stage 0 - First Run Scripts
  # This disables the welcome screen from the default user
  provisioner "shell" {
    inline = [
      "mkdir -p /home/${var.username}/.config/",
      "touch /home/${var.username}/.config/gnome-initial-setup-done",
    ]    
  }

  # Stage 1 - Ubuntu Tweak Scripts
  provisioner "shell" {
    # Note: sudo -S env is necessary ot pass the environment variables down to each script
    execute_command  = "echo '${var.password}' | sudo -S env {{ .Vars }} {{ .Path }}"
    environment_vars = local.script_environment_variables
    scripts = [
      "${path.root}/builtin_scripts/ubuntu/disable-aptdaily.sh",
      "${path.root}/builtin_scripts/ubuntu/system-update.sh",
      "${path.root}/builtin_scripts/ubuntu/open-vm-tools.sh",
      "${path.root}/builtin_scripts/ubuntu/virtualbox-guest-x11.sh",
      "${path.root}/builtin_scripts/ubuntu/setup-saltstack.sh",
      # Note: once https://github.com/hashicorp/packer/pull/10945 is merged, configure
      # sudo becomes optional and or purely a user experience option
      "${path.root}/builtin_scripts/ubuntu/configure-sudo.sh",
    ]
  }

  # Stage 3 - Custom Scripts
  # This section is for scripts that are added custom to the packer build not included
  # by the template, these can be anything that needs to happen to prepare the system
  provisioner "shell" {
    execute_command = "echo '${var.password}' | sudo -S -E bash '{{ .Path }}'"
    scripts = [
      "${path.root}/custom_scripts/nop.sh",
    ]
  }

  # Stage 4 - Saltstack
  provisioner "salt-masterless" {
    local_state_tree = "${path.root}/sift-saltstack"
    skip_bootstrap   = true
    # Uncomment this once PR () gets merged
    # execute_command  = "echo '${var.password}' | sudo -S -E"
    custom_state     = "sift.server"
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

  provisioner "file" {
    content = local.cloud_config
    destination = "/tmp/defaults.cfg"
  }

  provisioner "shell" {
    execute_command  = "echo '${var.password}' | sudo -S env {{ .Vars }} {{ .Path }}"
    inline = [
      "rm -f /home/${var.username}/.ssh/authorized_keys",
      "mv /tmp/defaults.cfg /etc/cloud/cloud.cfg.d/user_defaults.cfg",
      "chown root:root /etc/cloud/cloud.cfg.d/user_defaults.cfg",
      "cloud-init clean --logs --seed",
    ]
  }
}

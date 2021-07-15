build {
  sources = ["source.vmware-iso.preflight"]

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
}
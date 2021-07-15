
source "amazon-ebs" "full" {
  region        = var.aws_region
  source_ami    = var.aws_ami
  instance_type = var.aws_instance_type

  ssh_username   = var.username

  user_data = local.user_data

  ami_groups  = ["all"]
  ami_name    = "${var.name}-${local.timestamp}"
  ami_users   = var.aws_accounts
  ami_regions = var.aws_regions

  launch_block_device_mappings {
    delete_on_termination = true
    device_name           = "/dev/sda1"
    volume_size           = var.aws_volume_size
    volume_type           = "gp2"
  }

  source_ami_filter {
    filters = {
       virtualization-type = "hvm"
       name = var.aws_ami_source_filter_name
       root-device-type = "ebs"
    }
    owners = var.aws_ami_source_owner
    most_recent = true
  }
}

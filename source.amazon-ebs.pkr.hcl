locals {
  ami_name    = var.development_mode ? "development-${var.name}-${local.timestamp}" : "${var.name}-${local.timestamp}"
  ami_groups  = var.development_mode ? [] : ["all"]
  aws_regions = var.development_mode ? [] : var.aws_regions

  default_tags = {
    "Name" = local.ami_name,
  }

  resolved_tags = merge(local.default_tags, var.aws_tags)
}

source "amazon-ebs" "full" {
  region        = var.aws_region
  source_ami    = var.aws_ami
  instance_type = var.aws_instance_type

  ssh_username = var.username

  user_data = local.user_data

  ami_groups  = local.ami_groups
  ami_name    = local.ami_name
  ami_users   = var.aws_accounts
  ami_regions = local.aws_regions

  tags = local.resolved_tags

  launch_block_device_mappings {
    delete_on_termination = true
    device_name           = "/dev/sda1"
    volume_size           = var.aws_volume_size
    volume_type           = "gp3"
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

  vpc_filter {
    filters = var.aws_vpc_filters
  }

  subnet_filter {
    filters = var.aws_vpc_subnet_filters
  }
}

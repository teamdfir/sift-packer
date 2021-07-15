variable "name" {
  description = "The name of the virtual machine"
  type    = string
  default = "sift"
}

variable "output_directory" {
  description = "The location to build all virtual machines to"
  type    = string
  default = "_outputs"
}

variable "source_directory" {
  description = "The location to source a VMX from, leave blank for calculated"
  type = string
  default = ""
}

variable "username" {
  description = "The default username for the OS"
  type    = string
  default = "sansforensics"
}

variable "password" {
  description = "The password for the the default user for the OS"
  type    = string
  default = "forensics"
}

variable "ubuntu_images_url" {
  description = "The default place to obtain the OS images from"
  type    = string
  default = "http://archive.ubuntu.com/ubuntu/dists/focal/main/installer-amd64/current/legacy-images"
}

variable "accelerator" {
  description = "The accelerator to use, only useful with QEMU builds"
  type        = string
  default     = "kvm"
}

variable "headless" {
  description = "Whether or not to build the VM headless"
  type        = string
  default     = "false"
}

variable "cpus" {
  description = "The number of CPUs to give to the virtual machine during the build"
  type        = string
  default     = "4"
}

variable "memory" {
  description = "The amount of memory to give to the virtual machine during the build"
  type        = string
  default     = "4096"
}

variable "disk_size" {
  description = "Disk Size for the primary drive (in MB)"
  type        = string
  default     = "500000"
}

variable "vmware_disk_type_id" {
  description = "VMWare Disk Type ID"
  type        = number
  default     = 0
}

variable "http_proxy" {
  type = string
  default = ""
}
variable "https_proxy" {
  type = string
  default = ""
}
variable "no_proxy" {
  type = string
  default = ""
}

variable "aws_region" {
  description = "AWS Region to use by default for any AMI or EBS Builds"
  type = string
  default = "us-east-2"
}

variable "aws_regions" {
  description = "List of AWS Regions to copy the AMI to (only valid for amazon-ebs builder)"
  type = list(string)
  default = ["us-east-1", "us-east-2", "us-west-1", "us-west-2"]
}

variable "aws_ami" {
  description = "AWS Base AMI to build on top of (leave empty for source_filter to be used)"
  type        = string
  default     = ""
}

variable "aws_ami_source_filter_name" {
  description = "AWS Source AMI Filter Name"
  type        = string
  default     = "ubuntu/images/*ubuntu-focal-20.04-amd64-server-*"
}

variable "aws_ami_source_owner" {
  description = "AWS Source AMI Owner"
  type        = list(string)
  default     = ["099720109477"]
}

variable "aws_instance_type" {
  description = "AWS Instance Type"
  type        = string
  default     = "m4.xlarge"
}

variable "aws_volume_size" {
  description = "AWS Root Block Volume Size (expressed in GB)"
  type        = number
  default     = 20
}

variable "aws_accounts" {
  description = "AWS Accounts that any AMI created should be allowed to use"
  type        = list(string)
  default     = []
}

locals {
  timestamp = formatdate("YYYY-MM-DD-hhmm", timestamp())

  user_data = templatefile("builtin_files/aws-cloud-config.yaml", {
    username = var.username,
  })
  ubuntu_desktop_preseed = templatefile("builtin_files/ubuntu-desktop-preseed.cfg", {
    username = var.username,
    password = var.password,
  })

  boot_command = [
    "<tab>",
    "url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed ",
    "auto=true ",
    "net.ifnames=0 ",
    "hostname=localhost ",
    "<enter>",
  ]
  shutdown_command = "echo '${var.password}' | sudo -S shutdown -P now"

  iso_checksum = "file:${var.ubuntu_images_url}/SHA256SUMS"
  iso_urls     = ["${var.ubuntu_images_url}/netboot/mini.iso"]

  script_environment_variables = [
    "DEBIAN_FRONTEND=noninteractive",
    "SSH_USERNAME=${var.username}",
    "SSH_PASSWORD=${var.password}",
    "http_proxy=${var.http_proxy}",
    "https_proxy=${var.https_proxy}",
    "no_proxy=${var.no_proxy}",
  ]

  vmware_vmx_source = var.source_directory != "" ? var.source_directory : "${var.name}-vmware-iso"
}
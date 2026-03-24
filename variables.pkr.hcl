variable "name" {
  description = "The name of the virtual machine"
  type        = string
  default     = "sift"
}

variable "output_directory" {
  description = "The location to build all virtual machines to"
  type        = string
  default     = "_outputs"
}

variable "source_directory" {
  description = "The location to source a VMX from, leave blank for calculated"
  type        = string
  default     = ""
}

variable "username" {
  description = "The default username for the OS"
  type        = string
  default     = "sansforensics"
}

variable "password" {
  description = "The password for the the default user for the OS"
  type        = string
  default     = "forensics"
}

variable "arch" {
  description = "The architecture of the OS to build"
  type        = string
  default     = "amd64"
}

variable "ubuntu_version" {
  description = "The version of Ubuntu to use"
  type        = string
  default     = "24.04.3"
}

// Note: this is so you can specifically override the ISO file, otherwise it will be calculated
// based on the ubuntu_version and arch
variable "ubuntu_images_url" {
  description = "The default place to obtain the OS images from"
  type        = string
  default     = ""
}

// Note: this is so you can specifically override the ISO file, otherwise it will be calculated
// based on the ubuntu_version and arch
variable "ubuntu_images_iso_filename" {
  description = "The default filename for the server install"
  type        = string
  default     = ""
}

variable "headless" {
  description = "Whether or not to build the VM headless"
  type        = string
  default     = "true"
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
  type    = string
  default = ""
}
variable "https_proxy" {
  type    = string
  default = ""
}
variable "no_proxy" {
  type    = string
  default = ""
}

variable "aws_region" {
  description = "AWS Region to use by default for any AMI or EBS Builds"
  type        = string
  default     = "us-east-2"
}

variable "aws_regions" {
  description = "List of AWS Regions to copy the AMI to (only valid for amazon-ebs builder)"
  type        = list(string)
  default = [
    "us-east-1",
    "us-east-2",
    "us-west-1",
    "us-west-2",
    "eu-west-1",
    "eu-west-2",
    "eu-west-3",
    "eu-central-1",
    "eu-north-1",
    "ap-northeast-1",
    "ap-northeast-2",
    "ap-northeast-3",
    "ap-southeast-1",
    "ap-southeast-2",
  ]
}

// Note: this is so you can specifically override the AMI, otherwise it will be calculated
// based on the ubuntu_version and arch
variable "aws_ami" {
  description = "AWS Base AMI to build on top of (leave empty for source_filter to be used)"
  type        = string
  default     = ""
}

// Note: this is so you can specifically override the AMI source filter, otherwise it will be calculated
// based on the ubuntu_version and arch
variable "aws_ami_source_filter_name" {
  description = "AWS Source AMI Filter Name"
  type        = string
  default     = ""
}

variable "aws_ami_source_owner" {
  description = "AWS Source AMI Owner"
  type        = list(string)
  default     = ["099720109477"]
}

// Note: this is so you can specifically override the EC2 Instance type, otherwise it will be calculated
// based on the architecture specified.
variable "aws_instance_type" {
  description = "AWS Instance Type"
  type        = string
  default     = ""
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

variable "aws_vpc_filters" {
  description = "The filter used to select the VPC to launch AMI builders into"
  type        = map(string)
  default     = {}
}

variable "aws_vpc_subnet_filters" {
  description = "The filter used to select the subnet in the VPC to launch AMI builders into"
  type        = map(string)
  default     = {}
}

variable "aws_tags" {
  description = "Tags to add the the AMI image"
  type        = map(string)
  default     = {}
}

variable "development_mode" {
  description = "Enable development for the build"
  type        = bool
  default     = false
}

variable "github_token" {
  description = "GitHub Token to use for the build"
  type        = string
  default     = ""
}

locals {
  timestamp = formatdate("YYYY-MM-DD-hhmm", timestamp())

  cloud_config = templatefile("builtin_files/cloud-config.yaml", {
    hostname = var.name
    username = var.username
    password = bcrypt(var.password)
  })

  user_data = templatefile("builtin_files/aws-cloud-config.yaml", {
    username = var.username,
  })

  ubuntu_desktop_preseed = templatefile("builtin_files/ubuntu-desktop-preseed.cfg", {
    username = var.username,
    password = var.password,
  })

  boot_command = [
    "c<wait>",
    "linux /casper/vmlinuz --- autoinstall ds=\"nocloud-net;seedfrom=http://{{.HTTPIP}}:{{.HTTPPort}}/\" hostname=${var.name}",
    "<enter><wait>",
    "initrd /casper/initrd",
    "<enter><wait>",
    "boot",
    "<enter>"
  ]

  execute_command = "echo '${var.password}' | sudo -S env {{ .Vars }} {{ .Path }}"

  shutdown_command = "echo '${var.password}' | sudo -S shutdown -P now"

  ubuntu_version_parts = split(".", var.ubuntu_version)
  ubuntu_version_short = "${element(local.ubuntu_version_parts, 0)}.${element(local.ubuntu_version_parts, 1)}"

  aws_instance_prefix = var.arch == "arm64" ? "a1" : "m5"
  aws_instance_type   = var.aws_instance_type != "" ? var.aws_instance_type : "${local.aws_instance_prefix}.xlarge"
  aws_ami_filter_name = var.aws_ami_source_filter_name != "" ? var.aws_ami_source_filter_name : "ubuntu/images/*ubuntu-${local.ubuntu_version_short}-${var.arch}-server-*"

  ubuntu_images_url          = var.ubuntu_images_url != "" ? var.ubuntu_images_url : "https://releases.ubuntu.com/${local.ubuntu_version_short}"
  ubuntu_images_iso_filename = var.ubuntu_images_iso_filename != "" ? var.ubuntu_images_iso_filename : "ubuntu-${var.ubuntu_version}-live-server-${var.arch}.iso"

  iso_checksum = "file:${local.ubuntu_images_url}/SHA256SUMS"
  iso_urls     = ["${local.ubuntu_images_url}/${local.ubuntu_images_iso_filename}"]

  script_environment_variables = [
    "DEBIAN_FRONTEND=noninteractive",
    "SSH_USERNAME=${var.username}",
    "SSH_PASSWORD=${var.password}",
    "http_proxy=${var.http_proxy}",
    "https_proxy=${var.https_proxy}",
    "no_proxy=${var.no_proxy}",
    "GITHUB_TOKEN=${var.github_token}",
  ]

  vmware_vmx_source = var.source_directory != "" ? var.source_directory : "${var.name}-vmware-iso"

  guest_os_type = "ubuntu-64"
}

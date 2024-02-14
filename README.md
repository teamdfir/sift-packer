# SIFT - Packer - VM Builder

## Overview

This project will allow you to build the SIFT workstation to various targets.

## Requirements

- Have the latest version of packer installed (at least 1.7.2)

### Supported Builders

The following builds with checkmarks have been tested, the others are added but not tested.

- [x] VMWare ISO
- [x] VMWare VMX
- [x] Amazon EBS

## Usage

```bash
packer build --only=vmware-iso.full .
```

## Packer Primer

With Packer 1.5 and greater using the HCL language, packer is now divided into variables, sources, build.

## Tips & Tricks & Other Things to Know

### Development Speed

There are some other strategies that can be used to speed up the build time. For example you can leverage the `vmware-iso.preflight` build to build a basic image from ISO, then use the `vmware-vmx.full` to create a more comprehensive VM using the VMX from the first build as the source.

If you want to do iterative updates you can then use the target `vmware-vmx.update`. To build the VM from iso to complete you can use the `vmware-iso.full` target.

You will need to make changes to the source definitions and build definitions to support this model. For example you will not want to build the first image with saltstack only the second one.  The first one you'd want to change up and remove the saltstack definition and create a second set of build instructions for the second source only where saltstack will be called.

## Extending Packer Configurations

### Bash Scripts

You can add additional bash scripts to the `custom_scripts` folder and then modify the provisions in the `main.pkr.hcl` folder to include them in the correct order.

```hcl
provisioner "powershell" {
  scripts = [
    "${path.root}/custom_scripts/install-special-tool.sh",
  ]
}
```

### Exporting to OVA File

If you'd like to export the VM as an OVA, use the following code snippet and add to `main.pkr.hcl` or add to a new file.

Add the following to the top of the `post-processors` section in the main.pkr.hcl file.

```hcl
post-processor "shell-local" {
  inline = ["ovftool ${var.output_directory}-${var.name}/${var.name}.vmx ${var.output_directory}/${var.name}.ova"]
}

post-processor "artifice" {
  files = ["${var.output_directory}/${var.name}.ova"]
}
```

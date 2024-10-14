terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.1-rc4"
    }
  }
}

provider "proxmox" {
  pm_api_url      = "https://<ip>:8006/api2/json"
  pm_user         = "root@pam"
  pm_password     = "<passwd>"
  pm_tls_insecure = true
}

#resource "random_string" "vm_name_suffix" {
#  length  = 8
#  upper   = false
#  special = false
#}

resource "proxmox_vm_qemu" "clone_vm" {
  name        = var.vm_name
  desc        = "A test for using terraform and cloudinit"
  target_node = "innprox"
  clone       = var.template_name

  # VM settings
  agent   = 1
  os_type = "cloud-init"
  cores   = var.vm_cores
  sockets = 1
  memory  = var.vm_memory
  scsihw  = "virtio-scsi-pci"
  boot    = "order=scsi0"
  cpu     = "x86-64-v2-AES"

  # Setup the disks
  disks {
    ide {
      ide2 {
        cloudinit {
          storage = "local-lvm"
        }
      }
    }
    scsi {
      scsi0 {
        disk {
          size      = var.vm_storage
          cache     = "writeback"
          storage   = "local-lvm"
          replicate = true
        }
      }
    }
  }

  # Setup the network interface
  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  # Cloud-init configuration
  ipconfig0  = "ip=dhcp"
  ciuser     = var.ci_user
  cipassword = var.ci_passwd

  # Optional SSH keys configuration (uncomment if needed)
  # sshkeys = <<EOF
  # ssh-rsa 9182739187293817293817293871== user@pc
  # EOF

  # Serial console configuration
  serial {
    id   = 0
    type = "socket"
  }
}

# Output the VMID after the VM is created
output "new_vm_id" {
  value       = proxmox_vm_qemu.clone_vm.id
  description = "The VMID of the newly cloned VM"
}

# Null resource to fetch the IP using the newly created VMID
#resource "null_resource" "get_ip" {
#  provisioner "local-exec" {
#    command = "bash get_vm_ip.sh ${proxmox_vm_qemu.clone_vm.id}"
#  }
#
#  depends_on = [proxmox_vm_qemu.clone_vm]
#}

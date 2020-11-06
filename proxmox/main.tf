# Deploy VM on Proxmox with Terraform
# see provider.tf and variables.tf

terraform {
  required_providers {
    proxmox = {
      source  = "registry.example.com/telmate/proxmox"
      version = ">=1.0.0"
    }
  }
  required_version = ">= 0.13"
}


# How many vm do we want nb_vm=X
variable "nb_vm" {
  type = number
}

# Define VMs
resource "proxmox_vm_qemu" "proxmox_vm" {
  count             = var.nb_vm
  name              = "vm-0${count.index}"
  # Nom du node sur lequel le déploiement aura lieu
  target_node       = "Proxmox-VE"
  clone             = "debian-10-template"
  full_clone        = true
  os_type           = "cloud-init"
  cores             = 2
  sockets           = "1"
  cpu               = "host"
  memory            = 2048
  scsihw            = "virtio-scsi-pci"
  bootdisk          = "scsi0"
  disk {
    size            = "20G"
    type            = "scsi"
    storage         = "data"
   # type            = "lvm"
    iothread        = true
  }
  network {
    model           = "virtio"
    bridge          = "vmbr1"
  }

  # Cloud Init Settings
  ipconfig0         = "ip=192.168.0.10${count.index + 1}/24,gw=192.168.0.254"
  ciuser = "admuser"

  sshkeys = <<EOF
  ${var.ssh_key}
  EOF

  
  # Déclaration du script de démarrage, en utilisant user it-anthony + clé SSH privée
  provisioner "file" {
    source      = "./startup.sh"
    destination = "/tmp/startup.sh"
      connection {
      type     = "ssh"
      user     = "admuser"
      private_key     = "file(${pathexpand("~/.ssh/id_rsa")})"
      host     = self.ssh_host
      }
  }
  
  # Exécution du script de démarrage
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/startup.sh",
      "/tmp/startup.sh",
    ]
    connection {
      type     = "ssh"
      user     = "admuser"
      private_key     = "file(${pathexpand("~/.ssh/id_rsa")})"
      host     = self.ssh_host
    }
  }
}

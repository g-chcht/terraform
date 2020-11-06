#https://pve.proxmox.com/pve-docs/pve-admin-guide.html#qm_cloud_init

# Create VM debian-10-template, 2Go RAM, 1 proc, 2 cores
qm create 1000 -name debian-10-template -memory 2048 -net0 virtio,bridge=vmbr1 -cores 2 -sockets 1
# import the downloaded disk to local-lvm storage
#here "data" is the name of the storage configured in Proxmox !!
qm importdisk 1000 /var/lib/vz/template/qemu/debian-10-openstack-amd64.qcow2 data --format qcow2
# add disk to vm
qm set 1000 --scsihw virtio-scsi-pci --scsi0 data:1000/vm-1000-disk-0.qcow2
# add cdrom
qm set 1000 --cdrom data:cloudinit
#configure a serial console and use it as a display
qm set 1000 --serial0 socket --vga serial0
# Boot on disk
qm set 1000 --boot c --bootdisk scsi0

qm set 1000 -agent 1
qm set 1000 -hotplug disk,network,usb,memory,cpu
# 2 cores x1 sockets = 2 Vcpus
qm set 1000 -vcpus 2
# copy ssh key
qm set 1000 --sshkey ~/.ssh/id_rsa.pub

# resize disk to 20G
qm resize 1000 scsi0 +18G

# create template
qm template 1000

#!/bin/bash
sudo fdisk /dev/sdb << FINPART
n
p
1


t
1
8E
p
w
FINPART

sudo fdisk /dev/sdc << FINPART
n
p


+512M
n
p



t
1
8E
t
2
8E
p
w
FINPART

sudo wipefs -a /dev/sdb1 /dev/sdc1 /dev/sdc2
sudo pvcreate /dev/sdb1 /dev/sdc1 /dev/sdc2
sudo pvs
sudo vgcreate vg_datos /dev/sdb1
sudo vgcreate vg_temp /dev/sdc1 /dev/sdc2
sudo pvs
sudo vgs
sudo lvcreate -L 1.5G vg_datos -n lv_docker
sudo lvcreate -L 5M  vg_datos -n lv_workareas
sudo lvcreate -L 512M vg_temp -n lv_swap
sudo lvs
sudo vgs
sudo mkswap /dev/mapper/vg_temp-lv_swap
sudo swapon /dev/mapper/vg_temp-lv_swap
swapon -s
free -h
sudo mkfs.ext4 /dev/mapper/vg_datos-lv_docker
sudo mkfs.ext4 /dev/mapper/vg_datos-lv_workareas
sudo lsblk -f
sudo ls -l /var/lib/docker
sudo mkdir -p /work
sudo mount /dev/mapper/vg_datos-lv_docker /var/lib/docker
sudo mount /dev/mapper/vg_datos-lv_workareas /work
df -h
echo "/dev/vg_datos/lv_docker /var/lib/docker ext4 defaults 0 0" | sudo tee -a /etc/fstab
echo "/dev/vg_datos/lv_workareas /work ext4 defaults 0 0" | sudo tee -a /etc/fstab
echo "/dev/vg_temp/lv_swap swap swap defaults 0 0" | sudo tee -a /etc/fstab
sudo mount -a
sudo lsblk
df -h
cat /etc/fstab
df -h
sudo systemctl restart docker
sudo systemctl status docker
q


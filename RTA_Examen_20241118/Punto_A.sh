#!/bin/bash
sudo fdisk /dev/sdc <<EOF
n
p


+5M
n
p


+1.5G
t
1
8E
t 
2
8E
w
EOF

sudo fdisk /dev/sdb <<EOF
n
p


+512M
t
82
w
EOF

sudo wipefs -a /dev/sdc1 /dev/sdc2
sudo wipefs -a /dev/sdb1

sudo pvcreate  /dev/sdc1 /dev/sdc2
sudo pvcreate  /dev/sdb1

sudo vgcreate vg_datos /dev/sdc1 /dev/sdc2
sudo vgcreate vg_temp /dev/sdb1

sudo lvcreate -L 5M vg_datos -n lv_docker
sudo lvcreate -L 1.5G vg_datos -n lv_workareas
sudo lvcreate -L 512M vg_temp -n lv_swap

sudo mkfs -t ext4 /dev/mapper/vg_datos-lv_docker
sudo mkfs -t ext4 /dev/mapper/vg_datos-lv_workareas
sudo mkswap /dev/mapper/vg_temp-lv_swap

sudo mkdir -p /var/lib/docker
sudo mkdir -p /work

sudo mount /dev/mapper/vg_datos-lv_docker /var/lib/docker
sudo mount /dev/mapper/vg_datos-lv_workareas /work
sudo swapon /dev/mapper/vg_temp-lv_swap

sudo mount -a
sudo systemctl restart docker


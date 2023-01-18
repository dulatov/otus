#!/bin/bash

sudo yum install -y mdadm smartmontools hdparm gdisk nano

sudo mdadm --create /dev/md127 -l 5 -n 5 /dev/sd{a,c,d,e,f}

sudo mkdir /etc/mdadm

sudo echo "DEVICE partitions" > /etc/mdadm/mdadm.conf

sudo mdadm --detail --scan --verbose | awk '/ARRAY/ {print}' >> /etc/mdadm/mdadm.conf

sudo parted -s /dev/md127 mklabel gpt

parted /dev/md127 mkpart primary ext4 0% 20%
parted /dev/md127 mkpart primary ext4 20% 40%
parted /dev/md127 mkpart primary ext4 40% 60%
parted /dev/md127 mkpart primary ext4 60% 80%
parted /dev/md127 mkpart primary ext4 80% 100%

for i in $(seq 1 5); do sudo mkfs.ext4 /dev/md127p$i; done

mkdir -p /raid/part{1,2,3,4,5}

for i in $(seq 1 5); do mount /dev/md127p$i /raid/part$i; done



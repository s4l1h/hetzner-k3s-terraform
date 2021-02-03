#!/usr/bin/env bash

sudo fallocate -l ${swapsize}G /swapfile
sudo chown root:root /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo "/swapfile swap swap defaults 0 0" >> /etc/fstab

echo 5 > /proc/sys/vm/swappiness

echo "vm.swappiness=5" >> /etc/sysctl.conf

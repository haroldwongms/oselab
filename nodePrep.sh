#!/bin/bash
echo $(date) " - Starting Script"

# Create thin pool logical volume for Docker
echo $(date) " - Creating thin pool logical volume for Docker and staring service"

echo "DEVS=/dev/sdc" >> /etc/sysconfig/docker-storage-setup
echo "VG=docker-vg" >> /etc/sysconfig/docker-storage-setup
docker-storage-setup

# Enable and start Docker services

systemctl enable docker
systemctl start docker

echo $(date) " - Script Complete"


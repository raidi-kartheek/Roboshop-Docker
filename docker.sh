#!/bin/bash

set -ex

yum install -y yum-utils

yum-config-manager --add-repo \
https://download.docker.com/linux/rhel/docker-ce.repo

yum install -y docker-ce docker-ce-cli containerd.io \
docker-buildx-plugin docker-compose-plugin

systemctl enable docker
systemctl start docker

usermod -aG docker ec2-user

# Grow partition
sudo growpart /dev/ nvme0n1 4
sudo lvextend -L +10G /dev/mapper/RootVG-rootVol
sudo lvextend -L +10G /dev/mapper/RootVG-rootVol
sudo lvextend -L +10G /dev/mapper/RootVG-varVol

sudo xfs_growfs /var
sudo xfs_growfs /home
sudo xfs_growfs /
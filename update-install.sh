#!/usr/bin/env bash

sudo yum update -y
sudo yum install firewalld -y
sudo yum install -y yum-utils device-mapper-persistent-data lvm2
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y  docker-ce docker-ce-cli containerd.io
newgrp docker
sudo usermod -aG docker centos

sudo systemctl enable firewalld
sudo systemctl start firewalld
sudo firewall-cmd --add-service ssh --permanent
sudo firewall-cmd --reload

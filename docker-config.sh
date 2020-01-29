#!/usr/bin/env bash

sudo mkdir /etc/docker /etc/containers

sudo tee /etc/containers/registries.conf<<EOF
[registries.insecure]
registries = ['172.30.0.0/16']
EOF

sudo tee /etc/docker/daemon.json<<EOF
{
   "insecure-registries": [
     "172.30.0.0/16"
   ]
}
EOF

sudo systemctl daemon-reload
sudo systemctl restart docker
sudo systemctl enable docker

echo "net.ipv4.ip_forward = 1" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

DOCKER_BRIDGE=`sudo docker network inspect -f "{{range .IPAM.Config }}{{ .Subnet }}{{end}}" bridge`
sudo firewall-cmd --permanent --new-zone dockerc
sudo firewall-cmd --permanent --zone dockerc --add-source $DOCKER_BRIDGE
sudo firewall-cmd --permanent --zone dockerc --add-port={80,443,8443}/tcp
sudo firewall-cmd --permanent --zone dockerc --add-port={53,8053}/udp
sudo firewall-cmd --reload

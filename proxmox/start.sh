#!/bin/bash

sleep 5 && sudo apt update && sleep 5 && sudo apt upgrade -y && sleep 5 && sudo apt dist-upgrade -y && sleep 5

sudo apt -y install software-properties-common apt-transport-https ca-certificates curl gnupg2 software-properties-common && sleep 5

curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"
   
sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt update && sleep 5 && sudo apt install -y kubelet kubeadm kubernetes-cni

sleep 5 && sudo apt update && sleep 5 && sudo apt -y install docker-ce docker-ce-cli containerd.io htop vim qemu-guest-agent

sudo systemctl enable docker && sudo systemctl start docker


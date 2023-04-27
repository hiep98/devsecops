#!/bin/bash


echo "remove old docker"

sudo apt-get remove docker docker-engine docker.io containerd runc -y

echo "update apt database"
sudo apt-get update

echo "install certif, curl, gnupg, lsb-release"
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release -y



echo "installing containerd"
apt install containerd -y

echo "add google key and repo"
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

echo
echo "update apt database"
sudo apt-get update

echo
echo "installing kube tools"
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl


echo "Pulling k8s images"
kubeadm config images pull

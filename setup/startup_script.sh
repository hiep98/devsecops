#!/bin/bash

######### run sonarqube ######################
#sudo docker restart $(docker ps -a -q)
#docker run -d --name sonarqube -e SONAR_ES_BOOTSTRAP_CHECKS_DISABLE=true -p 9000:9000  -v sonarqube_data:/opt/sonarqube/data    sonarqube:lts
#sudo docker run -d --name sonarqube     -p 9000:9000     -v sonarqube_data:/opt/sonarqube/data     sonarqube:lts
sudo docker start sonarqube


######### Set static IP ######################
#sudo ip link set ens33 up
#sudo ip addr add 192.168.207.129/24 dev ens33
#sudo ip addr del 192.168.207.130/24 dev ens33

######### Swapoff ######################
# sudo swapoff -a
# strace -eopenat kubectl version
# sudo sed -i '/ swap / s/^/#/' /etc/fstab

echo "######### reset k8s  ######################"
#rm /root/.kube/config
#kubectl delete --all all | tee  k8s-delete.txt
#kubeadm reset -f | tee  k8s-reset.txt
#rm -rf /etc/cni/net.d || true
#rm -rf /var/lib/etcd || true
#rm -rf ~/.kube || true
#ip address delete {{ k8s_apiserver_vip_cidr }} dev {{ k8s_interface }}	

echo "######### kubeadm init  ######################"
# KUBE_VERSION=1.20.0
# # uncomment below line if your host doesnt have minimum requirement of 2 CPU
# # kubeadm init --kubernetes-version=${KUBE_VERSION} --ignore-preflight-errors=NumCPU --skip-token-print
# kubeadm init --kubernetes-version=${KUBE_VERSION} --skip-token-print  | tee  k8s-init.txt

# echo "######### renew k8s deployment ######################"
# mkdir -p ~/.kube
# sudo cp -i /etc/kubernetes/admin.conf ~/.kube/config
# kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml | tee  k8s-weave.txt

# sleep 60

# echo "######### set git commit id ######################"
# sudo cp /var/lib/jenkins/workspace/devsecops-app-num/k8s_deployment_service.yaml .
# GIT_COMMIT=$(git --git-dir=/var/lib/jenkins/workspace/devsecops-app-num/.git rev-parse HEAD)
# imageName="nthiep1998/numeric-app:${GIT_COMMIT}"
# sed -i "s#replace#${imageName}#g" k8s_deployment_service.yaml

# echo "######### k8s_deployment_service ######################"
# sudo kubectl apply -f  /var/lib/jenkins/workspace/devsecops-app-num/k8s_deployment_service.yaml | tee  k8s-deployment.txt

# sleep 60

# echo "untaint controlplane node"
# #kubectl taint node $(kubectl get nodes -o=jsonpath='{.items[].metadata.name}') node.kubernetes.io/not-ready:NoSchedule-
# kubectl taint node $(kubectl get nodes -o=jsonpath='{.items[].metadata.name}') node-role.kubernetes.io/master:NoSchedule-
# kubectl taint nodes $(kubectl get nodes -o=jsonpath='{.items[].metadata.name}') node.kubernetes.io/disk-pressure-

# kubectl get node -o wide  | tee  k8s-node.txt


######### move output ######################
# journalctl -u kubelet | tee k8s-kubelet.txt
# #sudo find . -type f -name 'k8s*.txt' -exec mv {} /home/dai/$(date '+%Y-%m-%d_%H-%M-%S') \;
# #sudo mkdir $(date '+%Y-%m-%d_%H-%M-%S') && find . -type f -name 'k8s*.txt' -exec mv {} $(date '+%Y-%m-%d_%H-%M-%S') \;
# #sudo mv $(date '+%Y-%m-%d_%H-%M-%S')/* /home/dai/

# sudo mkdir $(date '+%Y-%m-%d_%H-%M-%S') && find . -type f -name 'k8s*.txt' -exec mv {} $(date '+%Y-%m-%d_%H-%M-%S') \; && sudo mv $(date '+%Y-%m-%d_%H-%M-%S') /home/dai/



######### run webhook ######################
relay login -k 0a5530fe-6e09-4b74-bcbd-d79656922e3d -s BOxrwtfQNGkG
export RELAY_KEY=0a5530fe-6e09-4b74-bcbd-d79656922e3d
export RELAY_SECRET=BOxrwtfQNGkG
relay forward --bucket github-jenkins http://localhost:8080/github-webhook/


#  https://github.com/sidd-harth/kubernetes-devops-security/blob/main/setup/vm-install-script/install-script.sh

#    journalctl -xeu kubelet
#    journalctl -u kubelet
#    sudo tail -f /var/log/syslog
#    systemctl status kubelet
#   sudo cp /home/dai/script/startup_script.sh  /usr/local/bin/startup_script.sh

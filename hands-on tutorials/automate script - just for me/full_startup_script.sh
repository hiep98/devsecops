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

######### Swapoff - fix error failed to read kubelet config file ######################
sudo swapoff -a
#strace -eopenat kubectl version
#sudo sed -i '/ swap / s/^/#/' /etc/fstab
#sudo kubeadm token create --print-join-command --v=5
#cp /etc/kubernetes/admin.conf /root/.kube/config
#kubeadm token create --v=5
# ls -l /var/lib/kubelet/config.yaml
#sudo kubeadm init phase kubelet-start
# systemctl restart kubelet

 

echo "######### reset k8s  ######################"
#rm /root/.kube/config
#kubectl delete --all all | tee  k8s-delete.txt
kubeadm reset -f | tee  k8s-reset.txt
rm -rf /etc/cni/net.d || true
rm -rf /var/lib/etcd || true
rm -rf ~/.kube || true
#ip address delete {{ k8s_apiserver_vip_cidr }} dev {{ k8s_interface }}	

echo "######### kubeadm init  ######################"
KUBE_VERSION=1.20.0
# uncomment below line if your host doesnt have minimum requirement of 2 CPU
# kubeadm init --kubernetes-version=${KUBE_VERSION} --ignore-preflight-errors=NumCPU --skip-token-print
kubeadm init --kubernetes-version=${KUBE_VERSION} --skip-token-print  | tee  k8s-init.txt

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
export KUBECONFIG=/etc/kubernetes/admin.conf


echo "######### renew k8s deployment ######################"
mkdir -p ~/.kube
sudo cp -i /etc/kubernetes/admin.conf ~/.kube/config
kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml | tee  k8s-weave.txt

sleep 60

echo "untaint controlplane node"
#kubectl taint node $(kubectl get nodes -o=jsonpath='{.items[].metadata.name}') node.kubernetes.io/not-ready:NoSchedule-
#kubectl taint nodes $(kubectl get nodes -o=jsonpath='{.items[].metadata.name}') node.kubernetes.io/disk-pressure-
kubectl taint node $(kubectl get nodes -o=jsonpath='{.items[].metadata.name}') node-role.kubernetes.io/master:NoSchedule-

kubectl get node -o wide  | tee  k8s-node.txt


echo "######### set git commit id ######################"
echo $pwd | tee pwd.txt
sudo cp /var/lib/jenkins/workspace/devsecops-app-num/k8s_deployment_service.yaml .
GIT_COMMIT=$(git --git-dir=/var/lib/jenkins/workspace/devsecops-app-num/.git rev-parse HEAD)
imageName="nthiep1998/numeric-app:${GIT_COMMIT}"
sed -i "s#replace#${imageName}#g" k8s_deployment_service.yaml


## Deploy Node-Service in Kubernetes Default Namespace
kubectl -n default create deploy node-app --image siddharth67/node-service:v1 
kubectl -n default expose deploy node-app --name node-service --port 5000


echo "######### k8s_deployment_service ######################"
sudo kubectl apply -f  k8s_deployment_service.yaml | tee  k8s-deployment.txt

sleep 80



######### move output ######################
journalctl -u kubelet | tee k8s-kubelet.txt
sudo mkdir $(date '+%Y-%m-%d_%H-%M-%S') && find . -type f -name 'k8s*.txt' -exec mv {} $(date '+%Y-%m-%d_%H-%M-%S') \;
sudo mv $(date '+%Y-%m-%d_%H-%M-%S')/* /home/dai/

#sudo mkdir $(date '+%Y-%m-%d_%H-%M-%S') && find / -type f -name 'k8s*.txt' -exec mv {} $(date '+%Y-%m-%d_%H-%M-%S') \; && sudo mv $(date '+%Y-%m-%d_%H-%M-%S') /home/dai/



######### run webhook ######################
relay login -k 0a5530fe-6e09-4b74-bcbd-d79656922e3d -s BOxrwtfQNGkG
export RELAY_KEY=0a5530fe-6e09-4b74-bcbd-d79656922e3d
export RELAY_SECRET=BOxrwtfQNGkG
relay forward --bucket github-jenkins http://localhost:8080/github-webhook/

# get ngrok public IP
#sudo ngrok http 8080
#curl http://localhost:4040/api/tunnels | jq ".tunnels[0].public_url"


#ny

relay login -k 1531e6dc-543d-4350-8629-fc6c7dcae13d -s J0OrCFY5mqoE
export RELAY_KEY=1531e6dc-543d-4350-8629-fc6c7dcae13d
export RELAY_SECRET=J0OrCFY5mqoE
#relay forward --bucket github-jenkins http://localhost:8080/github-webhook/
relay forward --bucket github-jenkins http://localhost:8080

#  https://github.com/sidd-harth/kubernetes-devops-security/blob/main/setup/vm-install-script/install-script.sh

#    journalctl -xeu kubelet
#    journalctl -u kubelet
#    sudo tail -f /var/log/syslog
#    systemctl status kubelet
#   sudo cp /home/dai/script/startup_script.sh  /usr/local/bin/startup_script.sh

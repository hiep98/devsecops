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
relay forward --bucket github-jenkins http://localhost:8080/github-webhook/ &




#ny

relay login -k 1531e6dc-543d-4350-8629-fc6c7dcae13d -s J0OrCFY5mqoE
export RELAY_KEY=1531e6dc-543d-4350-8629-fc6c7dcae13d
export RELAY_SECRET=J0OrCFY5mqoE
#relay forward --bucket github-jenkins http://localhost:8080/github-webhook/
relay forward --bucket github-jenkins http://localhost:8080 &



AUTOGEN WEBHOOK

# get ngrok public IP
#sudo ngrok http 8080 &
#curl http://localhost:4040/api/tunnels | jq ".tunnels[0].public_url"

#!/bin/bash
sudo ngrok http 8080 &
# Set the repository name and webhook ID
REPO_NAME="devsecops"
WEBHOOK_ID="408723151"

# Set the new webhook URL
#jq -r is a command used to remove the quotes around a string in the output of the jq command. The -r option stands for "raw output".

NEW_URL=$(curl http://localhost:4040/api/tunnels | jq -r '.tunnels[].public_url')
#By default, jq outputs JSON data with quotes around strings. For example, if the jq command outputs the string "hello", it will be surrounded by quotes. However, if you use the -r option, jq will output the string without quotes. In the previous script, jq -r '.tunnels.public_url' is used to extract the public_url value from the JSON output of the curl command without quotes, so that it can be used in the JSON payload for the curl command that follows.

 
# Set the authorization token
AUTH_TOKEN="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"

OWNER="hiep98"
REPO_NAME="devsecops"


# Update the webhook URL using the GitHub API 

curl -L \
  -X PATCH \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $AUTH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/$OWNER/$REPO_NAME/hooks/$WEBHOOK_ID/config \
  -d '{"content_type":"json","url":"'$NEW_URL'"}'




#  https://github.com/sidd-harth/kubernetes-devops-security/blob/main/setup/vm-install-script/install-script.sh

#    journalctl -xeu kubelet
#    journalctl -u kubelet
#    sudo tail -f /var/log/syslog
#    systemctl status kubelet
#   sudo cp /home/dai/script/startup_script.sh  /usr/local/bin/startup_script.sh


echo '######### Swapoff ######################'
sudo swapoff -a
strace -eopenat kubectl version
sudo sed -i '/ swap / s/^/#/' /etc/fstab


echo '######### reset k8s  ######################'
rm /root/.kube/config
kubectl delete --all all
kubeadm reset -f

rm -rf /etc/cni/net.d || true
rm -rf /var/lib/etcd || true
rm -rf ~/.kube || true

# uncomment below line if your host doesnt have minimum requirement of 2 CPU
# kubeadm init --kubernetes-version=${KUBE_VERSION} --ignore-preflight-errors=NumCPU --skip-token-print

echo '######### init k8s deployment ######################'
kubeadm init --kubernetes-version=${KUBE_VERSION} --skip-token-print


echo '######### renew k8s deployment ######################'
mkdir -p ~/.kube
sudo cp -i /etc/kubernetes/admin.conf ~/.kube/config
kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml

sleep 60
#GIT_COMMIT= echo $(git --git-dir=/var/lib/jenkins/workspace/devsecops-app-num/.git rev-parse HEAD)
#imageName = "nthiep1998/numeric-app:${GIT_COMMIT}"
#sed -i "s#replace#${imageName}#g" k8s_deployment_service.yaml
#sudo kubectl apply -f  /var/lib/jenkins/workspace/devsecops-app-num/k8s_deployment_service.yaml

sleep 60

echo "untaint controlplane node"
kubectl taint node $(kubectl get nodes -o=jsonpath='{.items[].metadata.name}') node.kubernetes.io/not-ready:NoSchedule-
kubectl taint node $(kubectl get nodes -o=jsonpath='{.items[].metadata.name}') node-role.kubernetes.io/master:NoSchedule-
kubectl get node -o wide


journalctl -xeu kubelet


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

KUBE_VERSION=1.20.0
kubeadm init --kubernetes-version=${KUBE_VERSION} --skip-token-print

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
export KUBECONFIG=/etc/kubernetes/admin.conf

echo '######### renew k8s deployment ######################'
mkdir -p ~/.kube
sudo cp -i /etc/kubernetes/admin.conf ~/.kube/config
kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml
sleep 60


echo '######### devsecops deployment ######################'
sudo cp /var/lib/jenkins/workspace/devsecops-app-num/k8s_deployment_service.yaml .
GIT_COMMIT=$(git --git-dir=/var/lib/jenkins/workspace/devsecops-app-num/.git rev-parse HEAD)
imageName="nthiep1998/numeric-app:${GIT_COMMIT}"
sed -i "s#replace#${imageName}#g" k8s_deployment_service.yaml
sudo kubectl apply -f k8s_deployment_service.yaml

sleep 60
echo "untaint controlplane node"
kubectl taint node $(kubectl get nodes -o=jsonpath='{.items[].metadata.name}') node.kubernetes.io/not-ready:NoSchedule-
kubectl taint node $(kubectl get nodes -o=jsonpath='{.items[].metadata.name}') node-role.kubernetes.io/master:NoSchedule-
kubectl taint nodes --all node-role.kubernetes.io/master-
kubectl get node -o wide


systemctl restart kubelet

sleep 10

journalctl -xeu kubelet

exit 0
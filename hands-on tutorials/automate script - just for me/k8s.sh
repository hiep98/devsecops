rm /root/.kube/config
kubectl -n kube-system get cm kubeadm-config -o yaml
Rm -rf /etc/cni/net.d

kubeadm reset -f


 kubeadm init --kubernetes-version=1.26.3 --skip-token-print
 mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

 export KUBECONFIG=/etc/kubernetes/admin.conf
journalctl -xeu kubelet
kubectl get all

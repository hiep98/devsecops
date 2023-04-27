#Apr 03 13:33:52 dai kubelet[4046]: F0403 13:33:52.692564    4046 server.go:198] failed to load Kubelet config file /var/lib/kubelet/config.yaml, error failed to read kubelet config file "/var/lib/kubelet/config.yaml", error: open /var/lib/kubelet/config.yaml: no such file or directory

sudo rm  /var/lib/kubelet/config.yaml
sudo kubeadm init phase kubeconfig  all
#sudo cp /etc/kubernetes/kubelet.conf /var/lib/kubelet/config.yaml
#sudo kubeadm config print init-defaults --component-configs KubeletConfiguration > config.yaml
sudo kubeadm config print init-defaults --component-configs KubeletConfiguration > config.yaml
sudo systemctl restart kubelet
echo  journalctl -u kubelet


kubectl -n istio-system port-forward deploy/kiali 20001:20001 --address 192.168.207.129 &

kubectl -n istio-system port-forward deploy/kiali 20001:20001 --address 192.168.207.129 &

kubectl -n istio-system port-forward deploy/grafana 3000:3000 --address 192.168.207.129 &

kubectl -n istio-system port-forward deploy/prometheus 9090:9090 --address 192.168.207.129 &

kubectl -n istio-system port-forward deploy/jaeger   16686:16686  --address 192.168.207.129 &


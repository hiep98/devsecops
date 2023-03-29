#!/bin/bash
#k8s-deployment.sh
sed -i "s#replace#${imageName}#g" k8s_deployment_service.yaml
kubectl -n default apply -f k8s_deployment_service.yaml

kdic=$(kubectl diff -f k8s_deployment_service.yaml)
if [[ $(kubectl diff -f k8s_deployment_service.yaml) ]]; then
    echo "$kdic doesnt exist"
else
    echo "$kdic exist"
fi




# Get all pod names in current namespace
pods=$(kubectl get pods -o jsonpath='{.items[*].metadata.name}')

# Loop through each pod and describe its events
for pod in $pods; do
  echo "Getting events for pod: $pod"
  kubectl get events --field-selector involvedObject.name=$pod --all-namespaces | awk -v var="$pod" '$0 ~ var'
done
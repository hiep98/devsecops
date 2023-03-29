#!/bin/bash
#k8s-deployment.sh
DIFF_OUTPUT=$(kubectl diff -f k8s_deployment_service.yaml)

# if [ -n "$DIFF_OUTPUT" ]; then
#   # DIFF_OUTPUT is not empty, run your code here
# else
#   # DIFF_OUTPUT is empty, do nothing
# fi

#! $(kubectl diff -f k8s_deployment_service.yaml  >/dev/null 2>&1)


sed -i "s#replace#${imageName}#g" k8s_deployment_service.yaml
kubectl -n default get deployment ${deploymentName} > /dev/null

if [[ $? -ne 0 || ! $(kubectl diff -f k8s_deployment_service.yaml)="" ]]; then
    echo "deployment ${deploymentName} doesn't exist"
    kubectl -n default apply -f k8s_deployment_service.yaml
else
    echo "deployment ${deploymentName} exists"
    echo "image name - ${imageName}"
    kubectl -n default set image deploy ${deploymentName} ${containerName}=${imageName} --record=true
fi

# Get all pod names in current namespace
pods=$(kubectl get pods -o jsonpath='{.items[*].metadata.name}')

# Loop through each pod and describe its events
for pod in $pods; do
  echo "Getting events for pod: $pod"
  kubectl get events --field-selector involvedObject.name=$pod --all-namespaces | awk -v var="$pod" '$0 ~ var'
done
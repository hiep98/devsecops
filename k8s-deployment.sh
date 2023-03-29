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
#!/bin/bash
#k8s-deployment.sh
sed -i "s#replace#${imageName}#g" k8s_deployment_service.yaml
kubectl -n default get deployment ${deploymentName} > /dev/null

if [[ $? -ne 0 ]]; then
    echo "deployment ${deploymentName} doesn't exist"
    kubectl -n default apply -f k8s_deployment_service.yaml
else
    echo "deployment ${deploymentName} exists"
    echo "image name - ${imageName}"
    kubectl -n default set image deploy ${deploymentName} ${containerName}=${imageName} --record=true
fi

if [[ $(find k8s_deployment_service.yaml -mmin -1) ]] || [[ $? -ne 0 ]]; then
    echo "k8s_deployment_service.yaml has been updated in the last minute or the previous command failed"
    kubectl -n default apply -f k8s_deployment_service.yaml
else
    echo "k8s_deployment_service.yaml has not been updated in the last minute and the previous command was successful"
fi


kdif=$(kubectl diff -f k8s_deployment_service.yaml)
if [[ $(kubectl diff -f k8s_deployment_service.yaml) ]]; then
    echo "$kdif"
    echo "deployment ${deploymentName} doesnt exist"
else
    echo "$kdif"
    echo "deployment ${deploymentName} exist"
fi
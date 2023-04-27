sudo cp /var/lib/jenkins/workspace/devsecops-app-num/k8s_deployment_service.yaml .
GIT_COMMIT=$(git --git-dir=/var/lib/jenkins/workspace/devsecops-app-num/.git rev-parse HEAD)
imageName="nthiep1998/numeric-app:${GIT_COMMIT}"
sed -i "s#replace#${imageName}#g" k8s_deployment_service.yaml

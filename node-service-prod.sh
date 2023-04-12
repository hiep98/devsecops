#!/bin/bash

# Set the namespace name
namespace="prod"

# Check if the namespace exists
if kubectl get namespace "${namespace}" > /dev/null 2>&1; then
  # Check if the namespace has the istio-injection label
  if ! kubectl get namespace "${namespace}" -o jsonpath='{.metadata.labels.istio-injection}' | grep -q enabled; then
    # Add the istio-injection label to the namespace
    kubectl label namespace "${namespace}" istio-injection=enabled
    # Restart all deployments in the namespace to apply the label
    kubectl rollout restart deployment -n "${namespace}"
  else
    echo "namespace ${namespace} already has istio-injection label"
  fi
else
  # Create the namespace and add the istio-injection label
  kubectl create namespace "${namespace}"
  kubectl label namespace "${namespace}" istio-injection=enabled
fi

# Get the name and tag of the Docker image
image_info=$(docker images --format '{{.Repository}}:{{.Tag}}' | grep -i node-service)
if [ -n "${image_info}" ]; then
  image_name=$(echo "${image_info}" | cut -d ':' -f 1)
  image_tag=$(echo "${image_info}" | cut -d ':' -f 2)

  # Check if the deployment already exists
  if ! kubectl get deployment node-app -n "${namespace}" > /dev/null 2>&1; then
    # Create the deployment with 2 replicas and the specified image
    kubectl create deployment node-app --image "${image_name}:${image_tag}" --replicas 2 -n "${namespace}"
  else
    echo "deployment node-app already exists"
  fi

  # Check if the service already exists
  if ! kubectl get service node-service -n "${namespace}" > /dev/null 2>&1; then
    # Create a service for the deployment on port 5000
    kubectl expose deployment node-app --name node-service --port 5000 -n "${namespace}"
  else
    echo "service node-service already exists"
  fi
else
  echo "Docker image for node-service does not exist"
fi



#----------------------------------------
# #!/bin/bash
# # Check if the namespace prod exists
# if kubectl get namespace prod > /dev/null 2>&1; then
#   # Check if the label istio-injection=enabled exists in namespace prod
#   if ! kubectl get namespace prod -o jsonpath='{.metadata.labels.istio-injection}' | grep -q enabled; then
#     # Add the label istio-injection=enabled to namespace prod
#     kubectl label namespace prod istio-injection=enabled
#     kubectl rollout restart deployment node-app -n prod
#   else
#     echo "istio label exist"
#   fi
# else
#   # Create the namespace prod if it does not exist
#   kubectl create namespace prod
#   # Add the label istio-injection=enabled to namespace prod
#   kubectl label namespace prod istio-injection=enabled
#   kubectl rollout restart deployment node-app -n prod
# fi

# # Get the name of the Docker image node-service
# image_name=$(docker images | grep -i node-service | awk '{print $1}')

# # Check if the Docker image node-service exists
# if [ -n "$image_name" ]; then
#   # Get the image tag
#   image_tag=$(docker images | grep -i node-service | awk '{print $2}')

#   # Create a deployment and a service for the image
#   kubectl -n prod create deploy node-app --image $image_name:$image_tag --replicas 2
#   kubectl -n prod expose deploy node-app --name node-service --port 5000
# else
#   # Print an empty string if the image does not exist
#   echo "$image_name does not exist"
# fi

# ------------------------------
# #!/bin/bash

# # Check if the namespace prod exists
# if ! kubectl get namespace prod > /dev/null 2>&1; then
#   # Create the namespace prod if it does not exist
#   kubectl create namespace prod
# fi

# # Check if the Docker image node-service exists
# if docker images | grep -q node-service; then
#   # Get the image name and tag
#   image_name="node-service"
#   image_tag=$(docker images -q node-service)

#   # Create a deployment and a service for the image
#   kubectl -n prod create deploy node-app --image $image_name:$image_tag --replicas 2
#   kubectl -n prod expose deploy node-app --name node-service --port 5000
# else
#   # Print an empty string if the image does not exist
#   echo ""
# fi


# ---------------------------------------
# #!/bin/bash

# # Check if the namespace prod exists
# if ! kubectl get namespace prod > /dev/null 2>&1; then
#   # Create the namespace prod if it does not exist
#   kubectl create namespace prod
# fi

# # Check if the Docker image node-service exists
# if docker images | grep -q node-service; then
#   # Get the image tag
#   image_tag=$(docker images -q node-service)

#   # Create a deployment and a service for the image
#   kubectl -n prod create deploy node-app --image node-service:$image_tag --replicas 2
#   kubectl -n prod expose deploy node-app --name node-service --port 5000
# fi

# The script first checks if the namespace prod exists using kubectl get namespace prod. If the command fails, it means the namespace does not exist, so the script creates the namespace using kubectl create namespace prod.
# Next, the script checks if the Docker image node-service exists using docker images | grep -q node-service. If the image exists, it gets the image tag using docker images -q node-service. It then creates a deployment and a service for the image using kubectl -n prod create deploy node-app --image node-service:$image_tag --replicas 2 and kubectl -n prod expose deploy node-app --name node-service --port 5000.
# Note that the script assumes that the Docker image node-service has already been built and is available locally.




# Please writing bash shell follow idea below:
# if Kubernetes namespace prod not exist then create namespace 
# else  check if docker images have name node-service exist and kubectl -n prod create deploy node-app not exist then
# get the image name, tag and run command below 
# kubectl -n prod create deploy node-app --image <image name>:<image tag> --replicas 2
# kubectl -n prod expose deploy node-app --name node-service --port 5000
# else echo ""


# --------------
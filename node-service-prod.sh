#!/bin/bash

# Check if the namespace prod exists
if ! kubectl get namespace prod > /dev/null 2>&1; then
  # Create the namespace prod if it does not exist
  kubectl create namespace prod
fi

# Get the name of the Docker image node-service
image_name=$(docker images | grep -i node-service | awk '{print $1}')

# Check if the Docker image node-service exists
if [ -n "$image_name" ]; then
  # Get the image tag
  image_tag=$(docker images | grep -i node-service | awk '{print $2}')

  # Create a deployment and a service for the image
  kubectl -n prod create deploy node-app --image $image_name:$image_tag --replicas 2
  kubectl -n prod expose deploy node-app --name node-service --port 5000
else
  # Print an empty string if the image does not exist
  echo "$image_name does not exist"
fi







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
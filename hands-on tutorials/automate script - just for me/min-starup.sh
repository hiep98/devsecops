#!/bin/bash

######### run sonarqube ######################
sudo docker restart $(docker ps -a -q)
#docker run -d --name sonarqube -e SONAR_ES_BOOTSTRAP_CHECKS_DISABLE=true -p 9000:9000  -v sonarqube_data:/opt/sonarqube/data    sonarqube:lts
#sudo docker run -d --name sonarqube     -p 9000:9000     -v sonarqube_data:/opt/sonarqube/data     sonarqube:lts
#sudo docker start sonarqube


######### Swapoff - fix failed to read kubelet config file ######################
sudo swapoff -a
#strace -eopenat kubectl version
#sudo sed -i '/ swap / s/^/#/' /etc/fstab

######### run webhook ######################
#relay login -k 0a5530fe-6e09-4b74-bcbd-d79656922e3d -s BOxrwtfQNGkG
#export RELAY_KEY=0a5530fe-6e09-4b74-bcbd-d79656922e3d
#export RELAY_SECRET=BOxrwtfQNGkG

#relay forward --bucket github-jenkins http://localhost:8080/github-webhook/


relay login -k 1531e6dc-543d-4350-8629-fc6c7dcae13d -s J0OrCFY5mqoE
export RELAY_KEY=1531e6dc-543d-4350-8629-fc6c7dcae13d
export RELAY_SECRET=J0OrCFY5mqoE
#relay forward --bucket github-jenkins http://localhost:8080/github-webhook/
relay forward --bucket github-jenkins http://localhost:8080 &



#!/bin/bash
sudo ngrok http 8080 &
# Set the repository name and webhook ID
REPO_NAME="devsecops"
WEBHOOK_ID="408723151"

# Set the new webhook URL
#jq -r is a command used to remove the quotes around a string in the output of the jq command. The -r option stands for "raw output".

NEW_URL=$(curl http://localhost:4040/api/tunnels | jq -r '.tunnels[].public_url')
#By default, jq outputs JSON data with quotes around strings. For example, if the jq command outputs the string "hello", it will be surrounded by quotes. However, if you use the -r option, jq will output the string without quotes. In the previous script, jq -r '.tunnels.public_url' is used to extract the public_url value from the JSON output of the curl command without quotes, so that it can be used in the JSON payload for the curl command that follows.

 
# Set the authorization token
AUTH_TOKEN="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"

OWNER="hiep98"
REPO_NAME="devsecops"


# Update the webhook URL using the GitHub API 

curl -L \
  -X PATCH \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $AUTH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/$OWNER/$REPO_NAME/hooks/$WEBHOOK_ID/config \
  -d '{"content_type":"json","url":"'$NEW_URL'"}'

#  https://github.com/sidd-harth/kubernetes-devops-security/blob/main/setup/vm-install-script/install-script.sh

#    journalctl -xeu kubelet
#    journalctl -u kubelet
#    sudo tail -f /var/log/syslog
#    systemctl status kubelet
#   sudo cp /home/dai/script/startup_script.sh  /usr/local/bin/startup_script.sh

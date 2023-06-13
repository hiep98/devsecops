
## Source code used for hands-on lab
https://github.com/hiep98/devsecops/tree/main/devsecops-origin-resource

## NodeJS Microservice - Docker Image
`docker run -p 8787:5000 siddharth67/node-service:v1`

`curl localhost:8787/plusone/99`
 
## NodeJS Microservice - Kubernetes Deployment
`kubectl create deploy node-app --image siddharth67/node-service:v1`

`kubectl expose deploy node-app --name node-service --port 5000 --type ClusterIP`

`curl node-service-ip:5000/plusone/99`

## Hands-on Tutorial
https://hiep98.github.io/devsecops/

###  Markdown Hands-on Tutorial:
https://github.com/hiep98/devsecops/tree/main/hands-on%20tutorials/markdown

### Scripts used in labs: 
https://github.com/hiep98/devsecops/tree/main/hands-on%20tutorials/script-for-projects




NOTES: Devsecops lab starts from tutorial 1 to 31. Sections 32 to 39 are troubleshooting articles that can be encountered in practice.
 

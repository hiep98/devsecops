
## NodeJS Microservice - Docker Image
`docker run -p 8787:5000 siddharth67/node-service:v1`

`curl localhost:8787/plusone/99`
 
## NodeJS Microservice - Kubernetes Deployment
`kubectl create deploy node-app --image siddharth67/node-service:v1`

`kubectl expose deploy node-app --name node-service --port 5000 --type ClusterIP`

`curl node-service-ip:5000/plusone/99`

## Hands-on Tutorial
### Html
https://hiep98.github.io/devsecops/

### Markdown:
https://github.com/hiep98/devsecops/tree/main/hands-on%20tutorials/markdown

 NOTES: Devsecops lab starts from tutorial 1 to 31. Sections 32 to 39 are troubleshooting articles that can be encountered in practice.

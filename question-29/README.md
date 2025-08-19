# CKAD Simulation - Question 29

## Task

Team Sun needs a new Deployment named `sunny` with 4 replicas of image `nginx:1.17.3-alpine` in Namespace `sun`. The Deployment and its Pods should use the existing ServiceAccount `sa-sun-deploy`.

Create a ClusterIP Service named `sun-srv` which exposes the Deployment on port 9999. The target port should be the default port the nginx container is using.

Finally, create a new file `sunny_status_command.sh` which shows all resources of Namespace `sun`

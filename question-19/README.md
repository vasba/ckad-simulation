# Question 19 | Resource Requirements, Limits, Requests

## Task
Team Mars needs better resource management for their application. Create a Deployment named `mars-app` in Namespace `mars` with these specifications:

1. Use image `nginx:1.21.1-alpine`
2. Set 3 replicas
3. Container requests: 200m CPU, 256Mi memory
4. Container limits: 500m CPU, 512Mi memory
5. Add a liveness probe checking HTTP GET on port 80, path `/` with initial delay of 30 seconds and period of 10 seconds
6. Add a readiness probe checking HTTP GET on port 80, path `/` with initial delay of 5 seconds and period of 5 seconds

Save the Deployment yaml as `$HOME/ckad-simulation/19/mars-app-deployment.yaml` and apply it.

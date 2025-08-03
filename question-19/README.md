````markdown
# Question 19 | Resource Requirements, Limits, Requests

## Task
Team Mars needs better resource management for their application. Create a Deployment named `mars-app` in Namespace `mars` with these specifications:

1. Use image `nginx:1.21.1-alpine`
2. Set 3 replicas
3. Container requests: 200m CPU, 256Mi memory
4. Container limits: 500m CPU, 512Mi memory
5. Add a liveness probe checking HTTP GET on port 80, path `/` with initial delay of 30 seconds and period of 10 seconds
6. Add a readiness probe checking HTTP GET on port 80, path `/` with initial delay of 5 seconds and period of 5 seconds

Save the Deployment yaml as `/opt/course/19/mars-app-deployment.yaml` and apply it.

## Expected Answer

1. Generate base deployment:
```bash
kubectl -n mars create deployment mars-app --image=nginx:1.21.1-alpine --replicas=3 --dry-run=client -oyaml > mars-app-deployment.yaml
```

2. Edit to add resource requirements and probes:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mars-app
  namespace: mars
spec:
  replicas: 3
  selector:
    matchLabels:
      app: mars-app
  template:
    metadata:
      labels:
        app: mars-app
    spec:
      containers:
      - image: nginx:1.21.1-alpine
        name: nginx
        resources:
          requests:
            memory: "256Mi"
            cpu: "200m"
          limits:
            memory: "512Mi"
            cpu: "500m"
        livenessProbe:
          httpGet:
            path: /
            port: 80
          initialDelaySeconds: 30
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /
            port: 80
          initialDelaySeconds: 5
          periodSeconds: 5
```

3. Apply the deployment:
```bash
kubectl apply -f mars-app-deployment.yaml
```
````

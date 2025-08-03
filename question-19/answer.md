# Answer - Question 19 | Resource Requirements, Limits, Requests

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

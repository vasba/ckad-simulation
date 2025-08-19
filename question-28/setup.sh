#!/bin/bash

# Question 28 - Liveness Probe Setup
# Creates the necessary deployment for the liveness probe exercise

echo "Setting up Question 28 - Liveness Probe exercise..."

# Create the target directory (simulate being on ckad9043)
mkdir -p $HOME/ckad-simulation/28

# Create the pluto namespace
kubectl create namespace pluto --dry-run=client -o yaml | kubectl apply -f -

# Create the original deployment YAML file (without liveness probe)
cat > $HOME/ckad-simulation/28/project-23-api.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: project-23-api
  namespace: pluto
spec:
  replicas: 3
  selector:
    matchLabels:
      app: project-23-api
  template:
    metadata:
      labels:
        app: project-23-api
    spec:
      volumes:
      - name: cache-volume1
        emptyDir: {}
      - name: cache-volume2
        emptyDir: {}
      - name: cache-volume3
        emptyDir: {}
      containers:
      - image: httpd:2.4-alpine
        name: httpd
        ports:
        - containerPort: 80
        volumeMounts:
        - mountPath: /cache1
          name: cache-volume1
        - mountPath: /cache2
          name: cache-volume2
        - mountPath: /cache3
          name: cache-volume3
        env:
        - name: APP_ENV
          value: "prod"
        - name: APP_SECRET_N1
          value: "IO=a4L/XkRdvN8jM=Y+"
        - name: APP_SECRET_P1
          value: "-7PA0_Z]>{pwa43r)__"
EOF

# Apply the original deployment
kubectl apply -f $HOME/ckad-simulation/28/project-23-api.yaml

# Wait for deployment to be ready
echo "⏳ Waiting for deployment to be ready..."
kubectl rollout status deployment/project-23-api -n pluto --timeout=60s

echo "Setup complete for Question 28"
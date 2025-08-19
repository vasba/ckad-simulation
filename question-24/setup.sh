#!/bin/bash

# Question 24 - Service misconfiguration Setup
# Creates the necessary resources for the service misconfiguration exercise

echo "Setting up Question 24 - Service misconfiguration exercise..."

# Create the target directory (simulate being on ckad5601)
mkdir -p $HOME/ckad-simulation/24

# Create the mars namespace
kubectl create namespace mars --dry-run=client -o yaml | kubectl apply -f -

# Create the deployment with pods that have correct labels
cat > /tmp/manager-api-deployment.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: manager-api-deployment
  namespace: mars
  labels:
    app: manager-api-deployment
spec:
  replicas: 4
  selector:
    matchLabels:
      id: manager-api-pod
  template:
    metadata:
      labels:
        id: manager-api-pod
    spec:
      containers:
      - name: nginx
        image: nginx:1.21.1
        ports:
        - containerPort: 80
EOF

# Create the service with WRONG selector (this is the bug that needs to be fixed)
cat > /tmp/manager-api-service.yaml << 'EOF'
apiVersion: v1
kind: Service
metadata:
  name: manager-api-svc
  namespace: mars
  labels:
    app: manager-api-svc
spec:
  type: ClusterIP
  ports:
  - name: "4444-80"
    port: 4444
    protocol: TCP
    targetPort: 80
  selector:
    id: manager-api-deployment  # WRONG! Should be manager-api-pod
EOF

# Apply the resources
kubectl apply -f /tmp/manager-api-deployment.yaml
kubectl apply -f /tmp/manager-api-service.yaml

# Clean up temporary files
rm /tmp/manager-api-deployment.yaml
rm /tmp/manager-api-service.yaml

# Wait for deployment to be ready
echo "⏳ Waiting for deployment to be ready..."
kubectl rollout status deployment/manager-api-deployment -n mars --timeout=60s

echo "Setup complete for Question 24"
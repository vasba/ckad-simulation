#!/bin/bash

# Question 25 - Service ClusterIP->NodePort Setup
# Creates the necessary resources for the ClusterIP to NodePort conversion exercise

echo "Setting up Question 25 - Service ClusterIP->NodePort exercise..."

# Create the target directory (simulate being on ckad5601)
mkdir -p $HOME/ckad-simulation/25

# Create the jupiter namespace
kubectl create namespace jupiter --dry-run=client -o yaml | kubectl apply -f -

# Create the apache deployment
cat > /tmp/jupiter-crew-deploy.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: jupiter-crew-deploy
  namespace: jupiter
  labels:
    app: jupiter-crew-deploy
spec:
  replicas: 1
  selector:
    matchLabels:
      id: jupiter-crew
  template:
    metadata:
      labels:
        id: jupiter-crew
    spec:
      containers:
      - name: apache
        image: httpd:2.4.41-alpine
        ports:
        - containerPort: 80
EOF

# Create the ClusterIP service (this is what needs to be converted to NodePort)
cat > /tmp/jupiter-crew-svc.yaml << 'EOF'
apiVersion: v1
kind: Service
metadata:
  name: jupiter-crew-svc
  namespace: jupiter
  labels:
    app: jupiter-crew-svc
spec:
  type: ClusterIP
  ports:
  - name: "8080-80"
    port: 8080
    protocol: TCP
    targetPort: 80
  selector:
    id: jupiter-crew
EOF

# Apply the resources
kubectl apply -f /tmp/jupiter-crew-deploy.yaml
kubectl apply -f /tmp/jupiter-crew-svc.yaml

# Clean up temporary files
rm /tmp/jupiter-crew-deploy.yaml
rm /tmp/jupiter-crew-svc.yaml

# Wait for deployment to be ready
echo "⏳ Waiting for deployment to be ready..."
kubectl rollout status deployment/jupiter-crew-deploy -n jupiter --timeout=60s

echo "Setup complete for Question 25"
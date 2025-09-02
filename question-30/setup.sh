#!/bin/bash

echo "Setting up environment for Question 30..."

# Create namespace if it doesn't exist
kubectl get namespace earth >/dev/null 2>&1 || kubectl create namespace earth

# Create a problematic deployment (with wrong readiness probe port)
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: holy
  namespace: earth
spec:
  replicas: 2
  selector:
    matchLabels:
      app: holy
  template:
    metadata:
      labels:
        app: holy
    spec:
      containers:
      - name: nginx
        image: nginx:1.21.6-alpine
        ports:
        - containerPort: 80
        readinessProbe:
          httpGet:
            path: /
            port: 82    # Wrong port - should be 80
          initialDelaySeconds: 5
          periodSeconds: 5
EOF

# Create a service pointing to the deployment
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: holy-srv
  namespace: earth
spec:
  selector:
    app: holy
  ports:
  - port: 80
    targetPort: 80
  type: ClusterIP
EOF

# Wait a moment for resources to be created
sleep 5

echo "Environment setup complete!"
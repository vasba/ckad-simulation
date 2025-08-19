#!/bin/bash

# Question 23 - InitContainer Setup
# Creates the necessary deployment file for the InitContainer exercise

echo "Setting up Question 23 - InitContainer exercise..."

# Create the target directory (simulate being on ckad5601)
mkdir -p $HOME/ckad-simulation/23

# Create the mars namespace
kubectl create namespace mars --dry-run=client -o yaml | kubectl apply -f -

# Create the original deployment YAML file (before adding InitContainer)
cat > $HOME/ckad-simulation/23/test-init-container.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: test-init-container
  namespace: mars
spec:
  replicas: 1
  selector:
    matchLabels:
      id: test-init-container
  template:
    metadata:
      labels:
        id: test-init-container
    spec:
      volumes:
      - name: web-content
        emptyDir: {}
      containers:
      - image: nginx:1.17.3-alpine
        name: nginx
        volumeMounts:
        - name: web-content
          mountPath: /usr/share/nginx/html
        ports:
        - containerPort: 80
EOF

echo "Setup complete for Question 23"
echo "Student should:"
echo "1. Edit the deployment file at $HOME/ckad-simulation/23/test-init-container.yaml"
echo "2. Add an InitContainer named 'init-con' using busybox:1.31.0"
echo "3. InitContainer should create index.html with 'check this out!' content"
echo "4. Apply the deployment with: kubectl apply -f $HOME/ckad-simulation/23/test-init-container.yaml"
echo "5. Test with: kubectl run tmp --restart=Never --rm -i --image=nginx:alpine -- curl [POD_IP]"

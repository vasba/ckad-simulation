#!/bin/bash

# Question 16 - Logging sidecar Setup
# Creates all resources needed for this exercise

echo "Setting up Question 16 - Logging sidecar exercise..."

# Create mercury namespace
kubectl create namespace mercury --dry-run=client -o yaml | kubectl apply -f -

# Create the course directory
sudo mkdir -p /opt/course/16

# Create the original cleaner.yaml
cat <<EOF > /opt/course/16/cleaner.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: cleaner
  namespace: mercury
spec:
  replicas: 1
  selector:
    matchLabels:
      app: cleaner
  template:
    metadata:
      labels:
        app: cleaner
    spec:
      containers:
      - name: cleaner-con
        image: busybox:1.31.0
        command: ['sh', '-c', 'while true; do echo "\$(date) - Cleaning data..." >> /var/log/cleaner.log; echo "\$(date) - ERROR: Missing data incident detected!" >> /var/log/cleaner.log; sleep 10; done']
        volumeMounts:
        - name: logs
          mountPath: /var/log
      volumes:
      - name: logs
        emptyDir: {}
EOF

# Deploy the original cleaner deployment
kubectl apply -f /opt/course/16/cleaner.yaml

echo "Setup complete for Question 16"
echo "File created: /opt/course/16/cleaner.yaml"
echo "Deployment 'cleaner' created in namespace 'mercury'"
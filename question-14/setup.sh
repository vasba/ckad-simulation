#!/bin/bash

# Question 14 - Secret, Secret-Volume, Secret-Env Setup
# Creates all resources needed for this exercise

echo "Setting up Question 14 - Secret, Secret-Volume, Secret-Env exercise..."

# Create moon namespace
kubectl create namespace moon --dry-run=client -o yaml | kubectl apply -f -

# Create the course directory
sudo mkdir -p /opt/course/14

# Create the original Pod yaml
cat <<EOF > /opt/course/14/secret-handler.yaml
apiVersion: v1
kind: Pod
metadata:
  name: secret-handler
  namespace: moon
spec:
  containers:
  - name: secret-handler
    image: busybox:1.31.0
    command: ['sh', '-c', 'sleep 1d']
EOF

# Create secret2.yaml for the exercise
cat <<EOF > /opt/course/14/secret2.yaml
apiVersion: v1
kind: Secret
metadata:
  name: secret2
  namespace: moon
type: Opaque
data:
  halt: IyEgL2Jpbi9iYXNoCmVjaG8gIlN0b3BwaW5nIGFsbCBwcm9jZXNzZXMgbm93Li4uIg==
EOF

# Create the original Pod
kubectl apply -f /opt/course/14/secret-handler.yaml

echo "Setup complete for Question 14"
echo "Files created:"
echo "  - /opt/course/14/secret-handler.yaml"
echo "  - /opt/course/14/secret2.yaml"
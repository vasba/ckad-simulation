#!/bin/bash

# Question 7 - Pods, Namespaces Setup
# Creates the scenario with a Pod in saturn namespace

echo "Setting up Question 7 - Pods, Namespaces exercise..."

# Create saturn namespace if it doesn't exist
kubectl create namespace saturn --dry-run=client -o yaml | kubectl apply -f -

# Create neptune namespace if it doesn't exist
kubectl create namespace neptune --dry-run=client -o yaml | kubectl apply -f -

# Create several pods in saturn namespace to simulate the scenario
kubectl -n saturn run webserver-sat-001 --image=nginx:1.16.1-alpine
kubectl -n saturn run webserver-sat-002 --image=nginx:1.16.1-alpine
kubectl -n saturn run webserver-sat-004 --image=nginx:1.16.1-alpine
kubectl -n saturn run webserver-sat-005 --image=nginx:1.16.1-alpine
kubectl -n saturn run webserver-sat-006 --image=nginx:1.16.1-alpine

# Create the target pod with annotation and system label
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: webserver-sat-003
  namespace: saturn
  annotations:
    description: "this is the server for the E-Commerce System my-happy-shop"
  labels:
    id: webserver-sat-003
    system: my-happy-shop
spec:
  containers:
  - image: nginx:1.16.1-alpine
    imagePullPolicy: IfNotPresent
    name: webserver-sat
  restartPolicy: Always
EOF

echo "Setup complete for Question 7"
echo "Created pods in saturn namespace with my-happy-shop annotation and system label"
echo "Use 'kubectl -n saturn get pods --show-labels' to see all pods"
echo "Use 'kubectl -n saturn describe pod webserver-sat-003' to find the target"
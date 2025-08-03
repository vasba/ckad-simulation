#!/bin/bash

# Question 10 - Service, Logs Setup
# Creates the Pod and Service for testing

echo "Setting up Question 10 - Service, Logs exercise..."

# Create pluto namespace if it doesn't exist
kubectl create namespace pluto --dry-run=client -o yaml | kubectl apply -f -

# Create the course directory
mkdir -p /opt/course/10

# Create the Pod
kubectl -n pluto run project-plt-6cc-api --image=nginx:1.17.3-alpine --labels project=plt-6cc-api

# Wait for the Pod to be ready
echo "Waiting for Pod to be ready..."
kubectl -n pluto wait --for=condition=Ready pod/project-plt-6cc-api --timeout=60s

# Create the Service
kubectl -n pluto expose pod project-plt-6cc-api --name project-plt-6cc-svc --port 3333 --target-port 80

echo "Setup complete for Question 10"
echo "Pod project-plt-6cc-api and Service project-plt-6cc-svc created in pluto namespace"
echo "Use 'kubectl -n pluto get pod,svc' to see the resources"
echo "Test with: kubectl run tmp --restart=Never --rm -i --image=nginx:alpine -- curl http://project-plt-6cc-svc.pluto:3333"
#!/bin/bash

# Question 17 - Network Policy Setup
# Creates the environment for the network policy exercise

echo "Setting up Question 17 - Network Policy exercise..."

# Create venus namespace
kubectl create namespace venus --dry-run=client -o yaml | kubectl apply -f -

# Create the course directory
mkdir -p $HOME/ckad-simulation/17

# Create api deployment with label id=api
kubectl -n venus create deployment api --image=httpd:2.4.41-alpine --dry-run=client -o yaml | \
  sed 's/app: api/id: api/g' | kubectl apply -f -

# Expose api deployment on port 2222
kubectl -n venus expose deployment api --port=2222 --target-port=80

# Create frontend deployment with label id=frontend  
kubectl -n venus create deployment frontend --image=nginx:1.21.1-alpine --replicas=5 --dry-run=client -o yaml | \
  sed 's/app: frontend/id: frontend/g' | kubectl apply -f -

# Expose frontend deployment on port 80
kubectl -n venus expose deployment frontend --port=80 --target-port=80

echo "Setup complete for Question 17"
echo "Venus namespace created with api and frontend deployments"
echo "Student should create NetworkPolicy named np1"

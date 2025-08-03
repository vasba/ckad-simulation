#!/bin/bash

# Question 17 - Network Policy Setup
# Creates the environment for the network policy exercise

echo "Setting up Question 17 - Network Policy exercise..."

# Create sun namespace
kubectl create namespace sun --dry-run=client -o yaml | kubectl apply -f -

# Create the course directory
mkdir -p $HOME/ckad-simulation/17

# Create a test api pod for network policy testing
kubectl -n sun run api --image=nginx:1.21.1-alpine --labels=app=api

echo "Setup complete for Question 17"
echo "Sun namespace created with test api pod"
echo "Student should create frontend pod and network policies"

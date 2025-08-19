#!/bin/bash

# Question 26 - Requests and Limits, ServiceAccount Setup
# Creates the necessary resources for the resource requests/limits and ServiceAccount exercise

echo "Setting up Question 26 - Requests and Limits, ServiceAccount exercise..."

# Create the target directory (simulate being on ckad7326)
mkdir -p $HOME/ckad-simulation/26

# Create the neptune namespace
kubectl create namespace neptune --dry-run=client -o yaml | kubectl apply -f -

# Create the ServiceAccount neptune-sa-v2
kubectl create serviceaccount neptune-sa-v2 -n neptune --dry-run=client -o yaml | kubectl apply -f -

echo "Setup complete for Question 26"
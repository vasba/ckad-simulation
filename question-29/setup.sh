#!/bin/bash

echo "Setting up environment for Question 29..."

# Create namespace if it doesn't exist
kubectl get namespace sun >/dev/null 2>&1 || kubectl create namespace sun

# Create ServiceAccount if it doesn't exist  
kubectl get sa sa-sun-deploy -n sun >/dev/null 2>&1 || kubectl create serviceaccount sa-sun-deploy -n sun

echo "Environment setup complete!"
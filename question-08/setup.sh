#!/bin/bash

# Question 8 - Deployment, Rollouts Setup
# Creates a Deployment with a broken rollout

echo "Setting up Question 8 - Deployment, Rollouts exercise..."

# Create neptune namespace if it doesn't exist
kubectl create namespace neptune --dry-run=client -o yaml | kubectl apply -f -

# Create the initial working deployment
kubectl -n neptune create deployment api-new-c32 --image=nginx:1.16.1 --replicas=3

# Wait for the deployment to be ready
echo "Waiting for initial deployment to be ready..."
kubectl -n neptune rollout status deployment api-new-c32

# Record the change and update to a working version
kubectl -n neptune annotate deployment api-new-c32 deployment.kubernetes.io/revision-history-limit=10
kubectl -n neptune set image deployment api-new-c32 nginx=nginx:1.16.2 --record

# Wait for rollout
kubectl -n neptune rollout status deployment api-new-c32

# Now create a broken rollout with typo in image name
kubectl -n neptune set image deployment api-new-c32 nginx=ngnix:1.16.3 --record

# Wait a bit to let the rollout attempt happen
sleep 10

echo "Setup complete for Question 8"
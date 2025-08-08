#!/bin/bash

# Question 12 - Storage, PV, PVC, Pod volume Setup
# Creates only the prerequisite infrastructure

echo "Setting up Question 12 - Storage, PV, PVC, Pod volume exercise..."

# Create earth namespace if it doesn't exist
kubectl create namespace earth --dry-run=client -o yaml | kubectl apply -f -

# Create the host directory (simulate the hostPath)
sudo mkdir -p /Volumes/Data

echo "Setup complete for Question 12"
echo "Namespace 'earth' created and host directory '/Volumes/Data' prepared"
echo "Students should now create: PV, PVC, and Deployment as per task requirements"
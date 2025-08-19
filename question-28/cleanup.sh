#!/bin/bash

# Question 28 - Liveness Probe Cleanup
# Removes all resources created for this exercise

echo "Cleaning up Question 28 - Liveness Probe exercise..."

# Delete the deployment
kubectl delete deployment project-23-api -n pluto --ignore-not-found=true

# Delete any test pods that might have been created
kubectl delete pod tmp --ignore-not-found=true
kubectl delete pod tmp -n pluto --ignore-not-found=true

# Delete the pluto namespace
kubectl delete namespace pluto --ignore-not-found=true

# Remove the created files and directories
rm -rf $HOME/ckad-simulation/28

echo "Cleanup complete for Question 28"

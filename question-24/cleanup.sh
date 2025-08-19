#!/bin/bash

# Question 24 - Service misconfiguration Cleanup
# Removes all resources created for this exercise

echo "Cleaning up Question 24 - Service misconfiguration exercise..."

# Delete the deployment and service
kubectl delete deployment manager-api-deployment -n mars --ignore-not-found=true
kubectl delete service manager-api-svc -n mars --ignore-not-found=true

# Delete any test pods that might have been created
kubectl delete pod tmp --ignore-not-found=true
kubectl delete pod tmp -n mars --ignore-not-found=true

# Delete the mars namespace (this will also delete any remaining resources)
kubectl delete namespace mars --ignore-not-found=true

# Remove the created files and directories
rm -rf $HOME/ckad-simulation/24

echo "Cleanup complete for Question 24"

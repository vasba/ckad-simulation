#!/bin/bash

# Question 25 - Service ClusterIP->NodePort Cleanup
# Removes all resources created for this exercise

echo "Cleaning up Question 25 - Service ClusterIP->NodePort exercise..."

# Delete the deployment and service
kubectl delete deployment jupiter-crew-deploy -n jupiter --ignore-not-found=true
kubectl delete service jupiter-crew-svc -n jupiter --ignore-not-found=true

# Delete any test pods that might have been created
kubectl delete pod tmp --ignore-not-found=true
kubectl delete pod tmp -n jupiter --ignore-not-found=true

# Delete the jupiter namespace (this will also delete any remaining resources)
kubectl delete namespace jupiter --ignore-not-found=true

# Remove the created files and directories
rm -rf $HOME/ckad-simulation/25

echo "Cleanup complete for Question 25"

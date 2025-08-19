#!/bin/bash

# Question 23 - InitContainer Cleanup
# Removes all resources created for this exercise

echo "Cleaning up Question 23 - InitContainer exercise..."

# Delete the deployment if it exists
kubectl delete deployment test-init-container -n mars --ignore-not-found=true

# Delete any test pods that might have been created
kubectl delete pod tmp --ignore-not-found=true

# Delete the mars namespace (this will also delete the deployment)
kubectl delete namespace mars --ignore-not-found=true

# Remove the created files and directories
rm -rf $HOME/ckad-simulation/23

echo "Cleanup complete for Question 23"

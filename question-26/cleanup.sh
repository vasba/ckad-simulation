#!/bin/bash

# Question 26 - Requests and Limits, ServiceAccount Cleanup
# Removes all resources created for this exercise

echo "Cleaning up Question 26 - Requests and Limits, ServiceAccount exercise..."

# Delete the deployment
kubectl delete deployment neptune-10ab -n neptune --ignore-not-found=true

# Delete the ServiceAccount
kubectl delete serviceaccount neptune-sa-v2 -n neptune --ignore-not-found=true

# Delete the neptune namespace (this will also delete any remaining resources)
kubectl delete namespace neptune --ignore-not-found=true

# Remove the created files and directories
rm -rf $HOME/ckad-simulation/26

echo "Cleanup complete for Question 26"

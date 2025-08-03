#!/bin/bash

# Question 12 - Storage, PV, PVC, Pod volume Cleanup
# Removes all resources created for this exercise

echo "Cleaning up Question 12 - Storage, PV, PVC, Pod volume exercise..."

# Delete the Deployment if it exists
kubectl -n earth delete deployment project-earthflower --ignore-not-found=true

# Delete the PVC
kubectl -n earth delete pvc earth-project-earthflower-pvc --ignore-not-found=true

# Delete the PV
kubectl delete pv earth-project-earthflower-pv --ignore-not-found=true

# Remove the host directory
sudo rm -rf /Volumes/Data

echo "Cleanup complete for Question 12"
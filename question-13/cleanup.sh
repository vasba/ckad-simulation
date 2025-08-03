#!/bin/bash

# Question 13 - Storage, StorageClass, PVC Cleanup
# Removes all resources created for this exercise

echo "Cleaning up Question 13 - Storage, StorageClass, PVC exercise..."

# Delete the PVC
kubectl -n moon delete pvc moon-pvc-126 --ignore-not-found=true

# Delete the StorageClass
kubectl delete storageclass moon-retain --ignore-not-found=true

# Clean up the course directory
rm -rf $HOME/ckad-simulation/13

echo "Cleanup complete for Question 13"
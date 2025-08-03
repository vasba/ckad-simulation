#!/bin/bash

# Question 5 - ServiceAccount, Secret Cleanup
# Removes all resources created for this exercise

echo "Cleaning up Question 5 - ServiceAccount, Secret exercise..."

# Delete the ServiceAccount and Secret
kubectl -n neptune delete serviceaccount neptune-sa-v2 --ignore-not-found=true
kubectl -n neptune delete secret neptune-secret-1 --ignore-not-found=true

# Remove the created files and directories
# Clean up the course directory
rm -rf $HOME/ckad-simulation/5

# Note: We keep the neptune namespace as it might be used by other exercises

echo "Cleanup complete for Question 5"
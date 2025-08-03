#!/bin/bash

# Question 16 - Logging sidecar Cleanup
# Removes all resources created for this exercise

echo "Cleaning up Question 16 - Logging sidecar exercise..."

# Delete the Deployment
kubectl -n mercury delete deployment cleaner --ignore-not-found=true

# Clean up the course directory
rm -rf $HOME/ckad-simulation/16

echo "Cleanup complete for Question 16"
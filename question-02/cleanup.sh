#!/bin/bash

# Question 2 - Pods Cleanup
# Removes all resources created for this exercise

echo "Cleaning up Question 2 - Pods exercise..."

# Delete the pod
kubectl delete pod pod1 --ignore-not-found=true

# Remove the created files and directories
# Clean up the course directory
rm -rf $HOME/ckad-simulation/2

echo "Cleanup complete for Question 2"
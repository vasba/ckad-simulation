#!/bin/bash

# Question 2 - Pods Cleanup
# Removes all resources created for this exercise

echo "Cleaning up Question 2 - Pods exercise..."

# Delete the pod
kubectl delete pod pod1 --ignore-not-found=true

# Remove the created files and directories
rm -rf /opt/course/2

echo "Cleanup complete for Question 2"
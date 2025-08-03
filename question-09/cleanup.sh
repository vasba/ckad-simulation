#!/bin/bash

# Question 9 - Pod -> Deployment Cleanup
# Removes all resources created for this exercise

echo "Cleaning up Question 9 - Pod -> Deployment exercise..."

# Delete the Pod
kubectl -n pluto delete pod holy-api --ignore-not-found=true

# Delete the Deployment if it was created
kubectl -n pluto delete deployment holy-api --ignore-not-found=true

# Clean up the course directory
rm -rf /opt/course/9

echo "Cleanup complete for Question 9"
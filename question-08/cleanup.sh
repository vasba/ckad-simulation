#!/bin/bash

# Question 8 - Deployment, Rollouts Cleanup
# Removes all resources created for this exercise

echo "Cleaning up Question 8 - Deployment, Rollouts exercise..."

# Delete the deployment
kubectl -n neptune delete deployment api-new-c32 --ignore-not-found=true

echo "Cleanup complete for Question 8"
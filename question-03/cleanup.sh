#!/bin/bash

# Question 3 - Job Cleanup
# Removes all resources created for this exercise

echo "Cleaning up Question 3 - Job exercise..."

# Delete the job and its pods
kubectl -n neptune delete job neb-new-job --ignore-not-found=true

# Remove the created files and directories
# Clean up the course directory
rm -rf $HOME/ckad-simulation/3

# Note: We keep the neptune namespace as it might be used by other exercises

echo "Cleanup complete for Question 3"
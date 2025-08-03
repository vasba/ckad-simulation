#!/bin/bash

# Question 19 - Resource Requirements Cleanup
# Removes all resources created for this exercise

echo "Cleaning up Question 19 - Resource Requirements exercise..."

# Delete the Deployment
kubectl -n mars delete deployment mars-app --ignore-not-found=true

# Remove the course directory
# Clean up the course directory
rm -rf $HOME/ckad-simulation/19

echo "Cleanup complete for Question 19"

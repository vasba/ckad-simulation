#!/bin/bash

# Question 22 - Multi-container Pod Cleanup
# Removes all resources created for this exercise

echo "Cleaning up Question 22 - Multi-container Pod exercise..."

# Delete the Pod
kubectl -n cosmos delete pod cosmos-app --ignore-not-found=true

# Clean up the course directory
rm -rf $HOME/ckad-simulation/22

echo "Cleanup complete for Question 22"

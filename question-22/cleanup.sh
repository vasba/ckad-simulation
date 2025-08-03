#!/bin/bash

# Question 22 - Multi-container Pod Cleanup
# Removes all resources created for this exercise

echo "Cleaning up Question 22 - Multi-container Pod exercise..."

# Delete the Pod
kubectl -n cosmos delete pod cosmos-app --ignore-not-found=true

# Remove the course directory
sudo rm -rf /opt/course/22

echo "Cleanup complete for Question 22"

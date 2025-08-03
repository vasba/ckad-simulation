#!/bin/bash

# Question 19 - Resource Requirements Cleanup
# Removes all resources created for this exercise

echo "Cleaning up Question 19 - Resource Requirements exercise..."

# Delete the Deployment
kubectl -n mars delete deployment mars-app --ignore-not-found=true

# Remove the course directory
sudo rm -rf /opt/course/19

echo "Cleanup complete for Question 19"

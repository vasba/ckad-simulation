#!/bin/bash

# Question 27 - Labels, Annotations Cleanup
# Removes all resources created for this exercise

echo "Cleaning up Question 27 - Labels, Annotations exercise..."

# Delete the sun namespace (this will also delete all pods)
kubectl delete namespace sun --ignore-not-found=true

# Remove the created files and directories
rm -rf $HOME/ckad-simulation/27

echo "Cleanup complete for Question 27"

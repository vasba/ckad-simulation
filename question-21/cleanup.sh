#!/bin/bash

# Question 21 - SecurityContext Cleanup
# Removes all resources created for this exercise

echo "Cleaning up Question 21 - SecurityContext exercise..."

# Delete the Pod
kubectl -n galaxy delete pod galaxy-secure --ignore-not-found=true

# Remove the course directory
# Clean up the course directory
rm -rf $HOME/ckad-simulation/21

echo "Cleanup complete for Question 21"

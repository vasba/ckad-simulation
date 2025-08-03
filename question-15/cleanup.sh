#!/bin/bash

# Question 15 - ConfigMap, Configmap-Volume Cleanup
# Removes all resources created for this exercise

echo "Cleaning up Question 15 - ConfigMap, Configmap-Volume exercise..."

# Delete the Deployment
kubectl -n moon delete deployment web-moon --ignore-not-found=true

# Delete the ConfigMap
kubectl -n moon delete configmap configmap-web-moon-html --ignore-not-found=true

# Clean up the course directory
rm -rf $HOME/ckad-simulation/15

echo "Cleanup complete for Question 15"
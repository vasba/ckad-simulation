#!/bin/bash

# Question 14 - Secret, Secret-Volume, Secret-Env Cleanup
# Removes all resources created for this exercise

echo "Cleaning up Question 14 - Secret, Secret-Volume, Secret-Env exercise..."

# Delete the Pod
kubectl -n moon delete pod secret-handler --ignore-not-found=true

# Delete the Secrets
kubectl -n moon delete secret secret1 --ignore-not-found=true
kubectl -n moon delete secret secret2 --ignore-not-found=true

# Remove the course directory
sudo rm -rf /opt/course/14

echo "Cleanup complete for Question 14"
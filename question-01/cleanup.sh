#!/bin/bash

# Question 1 - Namespaces Cleanup
# Removes all resources created for this exercise

echo "Cleaning up Question 1 - Namespaces exercise..."

# Remove custom namespaces (keep system namespaces)
kubectl delete namespace earth --ignore-not-found=true
kubectl delete namespace jupiter --ignore-not-found=true  
kubectl delete namespace mars --ignore-not-found=true
kubectl delete namespace shell-intern --ignore-not-found=true

# Remove the created files and directories
rm -rf /opt/course/1

echo "Cleanup complete for Question 1"
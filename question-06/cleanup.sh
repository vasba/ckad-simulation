#!/bin/bash

# Question 6 - ReadinessProbe Cleanup
# Removes all resources created for this exercise

echo "Cleaning up Question 6 - ReadinessProbe exercise..."

# Delete the Pod
kubectl delete pod pod6 --ignore-not-found=true

# Remove the YAML file
rm -f pod6.yaml

echo "Cleanup complete for Question 6"
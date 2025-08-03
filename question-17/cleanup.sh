#!/bin/bash

# Question 17 - Network Policy Cleanup
# Removes all resources created for this exercise

echo "Cleaning up Question 17 - Network Policy exercise..."

# Delete the NetworkPolicies
kubectl -n sun delete networkpolicy frontend-deny --ignore-not-found=true
kubectl -n sun delete networkpolicy frontend-netpol --ignore-not-found=true

# Delete the Pods
kubectl -n sun delete pod frontend --ignore-not-found=true
kubectl -n sun delete pod api --ignore-not-found=true

# Remove the course directory
sudo rm -rf /opt/course/17

echo "Cleanup complete for Question 17"

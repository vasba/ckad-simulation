#!/bin/bash

# Question 18 - Ingress Cleanup
# Removes all resources created for this exercise

echo "Cleaning up Question 18 - Ingress exercise..."

# Delete the Ingress
kubectl -n venus delete ingress venus-ingress --ignore-not-found=true

# Delete the Services
kubectl -n venus delete service venus-app-svc --ignore-not-found=true
kubectl -n venus delete service venus-api-svc --ignore-not-found=true

# Delete the Pods
kubectl -n venus delete pod venus-app --ignore-not-found=true
kubectl -n venus delete pod venus-api --ignore-not-found=true

# Remove the course directory
sudo rm -rf /opt/course/18

echo "Cleanup complete for Question 18"

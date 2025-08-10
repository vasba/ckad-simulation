#!/bin/bash

# Question 17 - Network Policy Cleanup
# Removes all resources created for this exercise

echo "Cleaning up Question 17 - Network Policy exercise..."

# Delete the NetworkPolicy
kubectl -n venus delete networkpolicy np1 --ignore-not-found=true

# Delete the Services
kubectl -n venus delete service api --ignore-not-found=true
kubectl -n venus delete service frontend --ignore-not-found=true

# Delete the Deployments
kubectl -n venus delete deployment api --ignore-not-found=true
kubectl -n venus delete deployment frontend --ignore-not-found=true

# Delete the namespace (this will also delete any remaining resources)
kubectl delete namespace venus --ignore-not-found=true

# Remove the course directory
rm -rf $HOME/ckad-simulation/17

echo "Cleanup complete for Question 17"

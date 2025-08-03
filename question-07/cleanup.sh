#!/bin/bash

# Question 7 - Pods, Namespaces Cleanup
# Removes all resources created for this exercise

echo "Cleaning up Question 7 - Pods, Namespaces exercise..."

# Delete all pods in saturn namespace
kubectl -n saturn delete pod webserver-sat-001 --ignore-not-found=true
kubectl -n saturn delete pod webserver-sat-002 --ignore-not-found=true
kubectl -n saturn delete pod webserver-sat-003 --ignore-not-found=true
kubectl -n saturn delete pod webserver-sat-004 --ignore-not-found=true
kubectl -n saturn delete pod webserver-sat-005 --ignore-not-found=true
kubectl -n saturn delete pod webserver-sat-006 --ignore-not-found=true

# Delete the pod from neptune if it was moved there
kubectl -n neptune delete pod webserver-sat-003 --ignore-not-found=true

# Clean up any YAML files that might have been created
rm -f webserver.yaml
rm -f 7_webserver-sat-003.yaml

echo "Cleanup complete for Question 7"
#!/bin/bash

# Question 10 - Service, Logs Cleanup
# Removes all resources created for this exercise

echo "Cleaning up Question 10 - Service, Logs exercise..."

# Delete the Service
kubectl -n pluto delete service project-plt-6cc-svc --ignore-not-found=true

# Delete the Pod
kubectl -n pluto delete pod project-plt-6cc-api --ignore-not-found=true


echo "Cleanup complete for Question 10"
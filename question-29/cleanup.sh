#!/bin/bash

echo "Cleaning up Question 29 resources..."

# Delete deployment if it exists
kubectl delete deployment sunny -n sun --ignore-not-found=true

# Delete service if it exists  
kubectl delete service sun-srv -n sun --ignore-not-found=true

# Delete the script file
rm -f /opt/course/29/list.sh

# Note: We keep namespace sun and ServiceAccount sa-sun-deploy as they might be used by other questions

echo "Question 29 cleanup complete!"
echo ""
echo "Remaining in sun namespace:"
kubectl get all -n sun

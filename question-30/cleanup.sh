#!/bin/bash

echo "Cleaning up Question 30 resources..."

# Delete deployment if it exists
kubectl delete deployment holy -n earth --ignore-not-found=true

# Delete service if it exists  
kubectl delete service holy-srv -n earth --ignore-not-found=true

# Delete the ticket file
rm -f /opt/course/30/ticket.txt

# Note: We keep namespace earth as it might be used by other questions

echo "Question 30 cleanup complete!"
echo ""
echo "Remaining in earth namespace:"
kubectl get all -n earth

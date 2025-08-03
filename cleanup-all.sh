#!/bin/bash

# CKAD Simulation - Master Cleanup Script
# Cleans up all exercises for CKAD certification practice

echo "=========================================="
echo "CKAD Simulation - Cleaning up all exercises"
echo "=========================================="

# Function to run cleanup for a question if it exists
cleanup_question() {
    local question_num=$1
    local question_dir="question-$(printf "%02d" $question_num)"
    
    if [ -d "$question_dir" ] && [ -f "$question_dir/cleanup.sh" ]; then
        echo ""
        echo "Cleaning up Question $question_num..."
        cd "$question_dir"
        ./cleanup.sh
        cd ..
    fi
}

# Cleanup questions 1-22 (in reverse order to avoid dependency issues)
for i in {22..1}; do
    cleanup_question $i
done

# Clean up common namespaces that might have been created
echo ""
echo "Cleaning up common namespaces..."
kubectl delete namespace neptune --ignore-not-found=true
kubectl delete namespace mercury --ignore-not-found=true
kubectl delete namespace earth --ignore-not-found=true
kubectl delete namespace jupiter --ignore-not-found=true
kubectl delete namespace mars --ignore-not-found=true
kubectl delete namespace venus --ignore-not-found=true
kubectl delete namespace pluto --ignore-not-found=true
kubectl delete namespace moon --ignore-not-found=true
kubectl delete namespace sun --ignore-not-found=true
kubectl delete namespace saturn --ignore-not-found=true
kubectl delete namespace galaxy --ignore-not-found=true
kubectl delete namespace cosmos --ignore-not-found=true
kubectl delete namespace shell-intern --ignore-not-found=true

echo ""
echo "=========================================="
echo "Cleanup complete!"
echo "=========================================="
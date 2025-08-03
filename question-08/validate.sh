#!/bin/bash

# Validation script for Question 8 - Deployment, Rollouts
echo "=== Validating Question 8: Deployment, Rollouts ==="

# Check if deployment api-new-c32 exists in neptune namespace
if kubectl get deploy api-new-c32 -n neptune &>/dev/null; then
    echo "✅ PASS: api-new-c32 deployment exists in neptune namespace"
else
    echo "❌ FAIL: api-new-c32 deployment not found in neptune namespace"
    exit 1
fi

# Check if deployment is running successfully (all replicas ready)
ready_replicas=$(kubectl get deploy api-new-c32 -n neptune -o jsonpath='{.status.readyReplicas}')
desired_replicas=$(kubectl get deploy api-new-c32 -n neptune -o jsonpath='{.spec.replicas}')

if [[ "$ready_replicas" == "$desired_replicas" ]] && [[ "$ready_replicas" -gt 0 ]]; then
    echo "✅ PASS: Deployment is running successfully ($ready_replicas/$desired_replicas replicas ready)"
else
    echo "❌ FAIL: Deployment is not running successfully ($ready_replicas/$desired_replicas replicas ready)"
    exit 1
fi

# Check if deployment is using correct nginx image (not ngnix typo)
current_image=$(kubectl get deploy api-new-c32 -n neptune -o jsonpath='{.spec.template.spec.containers[0].image}')
if [[ "$current_image" == "nginx:"* ]] && [[ "$current_image" != "ngnix:"* ]]; then
    echo "✅ PASS: Deployment is using correct nginx image ($current_image)"
else
    echo "❌ FAIL: Deployment may still be using incorrect image ($current_image)"
    exit 1
fi

# Check if there are no failed pods
failed_pods=$(kubectl get pods -n neptune -l app=api-new-c32 --field-selector=status.phase=Failed --no-headers 2>/dev/null | wc -l)
if [[ "$failed_pods" -eq 0 ]]; then
    echo "✅ PASS: No failed pods found"
else
    echo "⚠️  WARNING: $failed_pods failed pods found (may be from previous deployment)"
fi

# Check rollout history exists
if kubectl rollout history deploy api-new-c32 -n neptune &>/dev/null; then
    echo "✅ PASS: Rollout history is available"
    
    # Check if there are at least 2 revisions (original and rollback)
    revision_count=$(kubectl rollout history deploy api-new-c32 -n neptune | grep -v REVISION | grep -v "^$" | wc -l)
    if [[ "$revision_count" -ge 2 ]]; then
        echo "✅ PASS: Multiple revisions found in rollout history ($revision_count revisions)"
    else
        echo "⚠️  WARNING: Only $revision_count revision(s) found in rollout history"
    fi
else
    echo "❌ FAIL: Rollout history not available"
    exit 1
fi

echo "🎉 All validations passed for Question 8!"

#!/bin/bash

# Validation script for Question 9 - Pod -> Deployment
echo "=== Validating Question 9: Pod -> Deployment ==="

# Check if holy-api-deployment.yaml file exists
if [[ -f "holy-api-deployment.yaml" ]]; then
    echo "✅ PASS: holy-api-deployment.yaml file exists"
else
    echo "❌ FAIL: holy-api-deployment.yaml file not found"
    exit 1
fi

# Check if file is a Deployment
if grep -q "kind: Deployment" holy-api-deployment.yaml; then
    echo "✅ PASS: holy-api-deployment.yaml is a Deployment"
else
    echo "❌ FAIL: holy-api-deployment.yaml is not a Deployment"
    exit 1
fi

# Check if file specifies apps/v1 API version
if grep -q "apiVersion: apps/v1" holy-api-deployment.yaml; then
    echo "✅ PASS: holy-api-deployment.yaml uses correct API version (apps/v1)"
else
    echo "❌ FAIL: holy-api-deployment.yaml does not use apps/v1 API version"
    exit 1
fi

# Check if deployment exists in pluto namespace
if kubectl get deploy holy-api -n pluto &>/dev/null; then
    echo "✅ PASS: holy-api deployment exists in pluto namespace"
else
    echo "❌ FAIL: holy-api deployment not found in pluto namespace"
    exit 1
fi

# Check if deployment has 3 replicas
replicas=$(kubectl get deploy holy-api -n pluto -o jsonpath='{.spec.replicas}')
if [[ "$replicas" == "3" ]]; then
    echo "✅ PASS: Deployment has 3 replicas"
else
    echo "❌ FAIL: Deployment has $replicas replicas, expected 3"
    exit 1
fi

# Check if deployment is running successfully
ready_replicas=$(kubectl get deploy holy-api -n pluto -o jsonpath='{.status.readyReplicas}')
if [[ "$ready_replicas" == "3" ]]; then
    echo "✅ PASS: All 3 replicas are ready"
else
    echo "❌ FAIL: Only $ready_replicas out of 3 replicas are ready"
    exit 1
fi

# Check if security context is configured
allowPrivilegeEscalation=$(kubectl get deploy holy-api -n pluto -o jsonpath='{.spec.template.spec.securityContext.allowPrivilegeEscalation}')
privileged=$(kubectl get deploy holy-api -n pluto -o jsonpath='{.spec.template.spec.securityContext.privileged}')

if [[ "$allowPrivilegeEscalation" == "false" ]]; then
    echo "✅ PASS: allowPrivilegeEscalation is set to false"
else
    echo "❌ FAIL: allowPrivilegeEscalation is not set to false"
    exit 1
fi

if [[ "$privileged" == "false" ]]; then
    echo "✅ PASS: privileged is set to false"
else
    echo "❌ FAIL: privileged is not set to false"
    exit 1
fi

# Check if original pod holy-api is deleted
if kubectl get pod holy-api -n pluto &>/dev/null; then
    echo "❌ FAIL: Original pod holy-api still exists and should have been deleted"
    exit 1
else
    echo "✅ PASS: Original pod holy-api has been deleted"
fi

# Check if deployment has proper selector and labels
selector_match=$(kubectl get deploy holy-api -n pluto -o jsonpath='{.spec.selector.matchLabels}')
if [[ -n "$selector_match" ]]; then
    echo "✅ PASS: Deployment has proper selector configured"
else
    echo "❌ FAIL: Deployment does not have proper selector configured"
    exit 1
fi

echo "🎉 All validations passed for Question 9!"

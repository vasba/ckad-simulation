#!/bin/bash

# Validation script for Question 2 - Pods
echo "=== Validating Question 2: Pods ==="

# Check if pod1 exists in default namespace
if kubectl get pod pod1 -n default &>/dev/null; then
    echo "✅ PASS: pod1 exists in default namespace"
else
    echo "❌ FAIL: pod1 not found in default namespace"
    exit 1
fi

# Check if pod1 is using httpd:2.4.41-alpine image
pod_image=$(kubectl get pod pod1 -n default -o jsonpath='{.spec.containers[0].image}')
if [[ "$pod_image" == "httpd:2.4.41-alpine" ]]; then
    echo "✅ PASS: pod1 is using correct image (httpd:2.4.41-alpine)"
else
    echo "❌ FAIL: pod1 is using wrong image ($pod_image), expected httpd:2.4.41-alpine"
    exit 1
fi

# Check if container name is 'pod1-container'
container_name=$(kubectl get pod pod1 -n default -o jsonpath='{.spec.containers[0].name}')
if [[ "$container_name" == "pod1-container" ]]; then
    echo "✅ PASS: Container name is correct (pod1-container)"
else
    echo "❌ FAIL: Container name is wrong ($container_name), expected pod1-container"
    exit 1
fi

# Check if pod1-status-command.sh exists and is executable
if [[ -f "pod1-status-command.sh" && -x "pod1-status-command.sh" ]]; then
    echo "✅ PASS: pod1-status-command.sh exists and is executable"
else
    echo "❌ FAIL: pod1-status-command.sh not found or not executable"
    exit 1
fi

# Check if the status command works and returns status
if ./pod1-status-command.sh | grep -i "status" &>/dev/null; then
    echo "✅ PASS: pod1-status-command.sh returns status information"
else
    echo "❌ FAIL: pod1-status-command.sh does not return status information"
    exit 1
fi

echo "🎉 All validations passed for Question 2!"

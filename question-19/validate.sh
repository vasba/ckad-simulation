#!/bin/bash

# Validation script for Question 19 - Resource Requirements, Limits, Requests
echo "=== Validating Question 19: Resource Requirements, Limits, Requests ==="

# Check if mars-app deployment exists in mars namespace
if kubectl get deployment mars-app -n mars &>/dev/null; then
    echo "✅ PASS: mars-app deployment exists in mars namespace"
else
    echo "❌ FAIL: mars-app deployment not found in mars namespace"
    exit 1
fi

# Check if deployment has 3 replicas
replicas=$(kubectl get deployment mars-app -n mars -o jsonpath='{.spec.replicas}')
if [[ "$replicas" == "3" ]]; then
    echo "✅ PASS: Deployment has 3 replicas"
else
    echo "❌ FAIL: Deployment has $replicas replicas, expected 3"
    exit 1
fi

# Check if deployment is running successfully
ready_replicas=$(kubectl get deployment mars-app -n mars -o jsonpath='{.status.readyReplicas}')
if [[ "$ready_replicas" == "3" ]]; then
    echo "✅ PASS: All 3 replicas are ready"
else
    echo "❌ FAIL: Only $ready_replicas out of 3 replicas are ready"
    exit 1
fi

# Check if deployment is using correct image
image=$(kubectl get deployment mars-app -n mars -o jsonpath='{.spec.template.spec.containers[0].image}')
if [[ "$image" == "nginx:1.21.1-alpine" ]]; then
    echo "✅ PASS: Deployment is using correct image (nginx:1.21.1-alpine)"
else
    echo "❌ FAIL: Deployment is using wrong image ($image), expected nginx:1.21.1-alpine"
    exit 1
fi

# Check resource requests
memory_request=$(kubectl get deployment mars-app -n mars -o jsonpath='{.spec.template.spec.containers[0].resources.requests.memory}')
cpu_request=$(kubectl get deployment mars-app -n mars -o jsonpath='{.spec.template.spec.containers[0].resources.requests.cpu}')

if [[ "$memory_request" == "256Mi" ]]; then
    echo "✅ PASS: Memory request is correct (256Mi)"
else
    echo "❌ FAIL: Memory request is wrong ($memory_request), expected 256Mi"
    exit 1
fi

if [[ "$cpu_request" == "100m" ]]; then
    echo "✅ PASS: CPU request is correct (100m)"
else
    echo "❌ FAIL: CPU request is wrong ($cpu_request), expected 100m"
    exit 1
fi

# Check resource limits
memory_limit=$(kubectl get deployment mars-app -n mars -o jsonpath='{.spec.template.spec.containers[0].resources.limits.memory}')
cpu_limit=$(kubectl get deployment mars-app -n mars -o jsonpath='{.spec.template.spec.containers[0].resources.limits.cpu}')

if [[ "$memory_limit" == "512Mi" ]]; then
    echo "✅ PASS: Memory limit is correct (512Mi)"
else
    echo "❌ FAIL: Memory limit is wrong ($memory_limit), expected 512Mi"
    exit 1
fi

if [[ "$cpu_limit" == "200m" ]]; then
    echo "✅ PASS: CPU limit is correct (200m)"
else
    echo "❌ FAIL: CPU limit is wrong ($cpu_limit), expected 200m"
    exit 1
fi

# Check if liveness probe exists
liveness_probe=$(kubectl get deployment mars-app -n mars -o jsonpath='{.spec.template.spec.containers[0].livenessProbe}')
if [[ -n "$liveness_probe" ]] && [[ "$liveness_probe" != "null" ]]; then
    echo "✅ PASS: Liveness probe is configured"
else
    echo "❌ FAIL: Liveness probe is not configured"
    exit 1
fi

# Check if readiness probe exists
readiness_probe=$(kubectl get deployment mars-app -n mars -o jsonpath='{.spec.template.spec.containers[0].readinessProbe}')
if [[ -n "$readiness_probe" ]] && [[ "$readiness_probe" != "null" ]]; then
    echo "✅ PASS: Readiness probe is configured"
else
    echo "❌ FAIL: Readiness probe is not configured"
    exit 1
fi

echo "🎉 All validations passed for Question 19!"

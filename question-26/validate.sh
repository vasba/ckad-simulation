#!/bin/bash

# Validation script for Question 26 - Requests and Limits, ServiceAccount
echo "=== Validating Question 26: Requests and Limits, ServiceAccount ==="

# Check if the neptune namespace exists
if ! kubectl get namespace neptune &>/dev/null; then
    echo "❌ FAIL: Namespace 'neptune' not found"
    exit 1
fi

echo "✅ PASS: Namespace 'neptune' exists"

# Check if the ServiceAccount exists
if ! kubectl get serviceaccount neptune-sa-v2 -n neptune &>/dev/null; then
    echo "❌ FAIL: ServiceAccount 'neptune-sa-v2' not found in namespace 'neptune'"
    exit 1
fi

echo "✅ PASS: ServiceAccount 'neptune-sa-v2' exists"

# Check if the deployment exists
if ! kubectl get deployment neptune-10ab -n neptune &>/dev/null; then
    echo "❌ FAIL: Deployment 'neptune-10ab' not found in namespace 'neptune'"
    exit 1
fi

echo "✅ PASS: Deployment 'neptune-10ab' exists"

# Check if deployment has correct number of replicas
REPLICAS=$(kubectl get deployment neptune-10ab -n neptune -o jsonpath='{.spec.replicas}')
if [[ "$REPLICAS" != "3" ]]; then
    echo "❌ FAIL: Expected 3 replicas, found: $REPLICAS"
    exit 1
fi

echo "✅ PASS: Deployment configured with 3 replicas"

# Check if deployment has correct number of ready replicas
READY_REPLICAS=$(kubectl get deployment neptune-10ab -n neptune -o jsonpath='{.status.readyReplicas}')
if [[ "$READY_REPLICAS" != "3" ]]; then
    echo "❌ FAIL: Expected 3 ready replicas, found: $READY_REPLICAS"
    exit 1
fi

echo "✅ PASS: Deployment has 3 ready replicas"

# Check if pods are using the correct image
IMAGE=$(kubectl get deployment neptune-10ab -n neptune -o jsonpath='{.spec.template.spec.containers[0].image}')
if [[ "$IMAGE" != "httpd:2.4-alpine" ]]; then
    echo "❌ FAIL: Expected image 'httpd:2.4-alpine', found: '$IMAGE'"
    exit 1
fi

echo "✅ PASS: Deployment uses correct image 'httpd:2.4-alpine'"

# Check if container has correct name
CONTAINER_NAME=$(kubectl get deployment neptune-10ab -n neptune -o jsonpath='{.spec.template.spec.containers[0].name}')
if [[ "$CONTAINER_NAME" != "neptune-pod-10ab" ]]; then
    echo "❌ FAIL: Expected container name 'neptune-pod-10ab', found: '$CONTAINER_NAME'"
    exit 1
fi

echo "✅ PASS: Container has correct name 'neptune-pod-10ab'"

# Check if serviceAccountName is set correctly
SERVICE_ACCOUNT=$(kubectl get deployment neptune-10ab -n neptune -o jsonpath='{.spec.template.spec.serviceAccountName}')
if [[ "$SERVICE_ACCOUNT" != "neptune-sa-v2" ]]; then
    echo "❌ FAIL: Expected serviceAccountName 'neptune-sa-v2', found: '$SERVICE_ACCOUNT'"
    exit 1
fi

echo "✅ PASS: ServiceAccount 'neptune-sa-v2' is configured"

# Check memory request
MEMORY_REQUEST=$(kubectl get deployment neptune-10ab -n neptune -o jsonpath='{.spec.template.spec.containers[0].resources.requests.memory}')
if [[ "$MEMORY_REQUEST" != "20Mi" ]]; then
    echo "❌ FAIL: Expected memory request '20Mi', found: '$MEMORY_REQUEST'"
    exit 1
fi

echo "✅ PASS: Memory request set to '20Mi'"

# Check memory limit
MEMORY_LIMIT=$(kubectl get deployment neptune-10ab -n neptune -o jsonpath='{.spec.template.spec.containers[0].resources.limits.memory}')
if [[ "$MEMORY_LIMIT" != "50Mi" ]]; then
    echo "❌ FAIL: Expected memory limit '50Mi', found: '$MEMORY_LIMIT'"
    exit 1
fi

echo "✅ PASS: Memory limit set to '50Mi'"

# Verify all pods are running
POD_COUNT=$(kubectl get pods -n neptune -l app=neptune-10ab --field-selector=status.phase=Running --no-headers | wc -l)
if [[ "$POD_COUNT" != "3" ]]; then
    echo "❌ FAIL: Expected 3 running pods, found: $POD_COUNT"
    exit 1
fi

echo "✅ PASS: All 3 pods are running"

# Check if pods are actually using the ServiceAccount
ACTUAL_SA=$(kubectl get pods -n neptune -l app=neptune-10ab -o jsonpath='{.items[0].spec.serviceAccountName}')
if [[ "$ACTUAL_SA" != "neptune-sa-v2" ]]; then
    echo "❌ FAIL: Pods are using ServiceAccount '$ACTUAL_SA', expected 'neptune-sa-v2'"
    exit 1
fi

echo "✅ PASS: Pods are using correct ServiceAccount 'neptune-sa-v2'"

# Display pod names for reference
echo ""
echo "📋 Running pods:"
kubectl get pods -n neptune -l app=neptune-10ab --no-headers | awk '{print "  - " $1 " (" $3 ")"}'

echo ""
echo "🎉 All validation checks passed!"
echo "Deployment successfully created with correct resource limits and ServiceAccount"

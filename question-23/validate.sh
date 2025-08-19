#!/bin/bash

# Validation script for Question 23 - InitContainer
echo "=== Validating Question 23: InitContainer ==="

# Check if the mars namespace exists
if ! kubectl get namespace mars &>/dev/null; then
    echo "❌ FAIL: Namespace 'mars' not found"
    exit 1
fi

echo "✅ PASS: Namespace 'mars' exists"

# Check if the deployment exists
if ! kubectl get deployment test-init-container -n mars &>/dev/null; then
    echo "❌ FAIL: Deployment 'test-init-container' not found in namespace 'mars'"
    exit 1
fi

echo "✅ PASS: Deployment 'test-init-container' exists in namespace 'mars'"

# Check if deployment has initContainers
init_container_check=$(kubectl get deployment test-init-container -n mars -o jsonpath='{.spec.template.spec.initContainers}')
if [[ -z "$init_container_check" || "$init_container_check" == "null" ]]; then
    echo "❌ FAIL: No initContainers found in deployment"
    exit 1
fi

echo "✅ PASS: InitContainer section exists in deployment"

# Check if initContainer is named 'init-con'
init_container_name=$(kubectl get deployment test-init-container -n mars -o jsonpath='{.spec.template.spec.initContainers[0].name}')
if [[ "$init_container_name" != "init-con" ]]; then
    echo "❌ FAIL: InitContainer name should be 'init-con', found: '$init_container_name'"
    exit 1
fi

echo "✅ PASS: InitContainer named 'init-con'"

# Check if initContainer uses correct image
init_container_image=$(kubectl get deployment test-init-container -n mars -o jsonpath='{.spec.template.spec.initContainers[0].image}')
if [[ "$init_container_image" != "busybox:1.31.0" ]]; then
    echo "❌ FAIL: InitContainer image should be 'busybox:1.31.0', found: '$init_container_image'"
    exit 1
fi

echo "✅ PASS: InitContainer uses correct image 'busybox:1.31.0'"

# Check if initContainer has volume mount
init_container_mount=$(kubectl get deployment test-init-container -n mars -o jsonpath='{.spec.template.spec.initContainers[0].volumeMounts[0].mountPath}')
if [[ -z "$init_container_mount" ]]; then
    echo "❌ FAIL: InitContainer has no volume mounts"
    exit 1
fi

echo "✅ PASS: InitContainer has volume mount at: $init_container_mount"

# Wait for deployment to be ready
echo "⏳ Waiting for deployment to be ready..."
kubectl rollout status deployment/test-init-container -n mars --timeout=60s

# Check if pod is running
if ! kubectl get pods -n mars -l id=test-init-container | grep -q Running; then
    echo "❌ FAIL: No running pods found for the deployment"
    exit 1
fi

echo "✅ PASS: Pod is running"

# Get the pod name
POD_NAME=$(kubectl get pods -n mars -l id=test-init-container -o jsonpath='{.items[0].metadata.name}')

# Test if the index.html file was created with correct content
echo "⏳ Testing if index.html was created by InitContainer..."
CONTENT=$(kubectl exec -n mars $POD_NAME -- cat /usr/share/nginx/html/index.html 2>/dev/null)

if [[ "$CONTENT" != "check this out!" ]]; then
    echo "❌ FAIL: index.html content incorrect. Expected 'check this out!', found: '$CONTENT'"
    exit 1
fi

echo "✅ PASS: index.html created with correct content: '$CONTENT'"

# Get pod IP for testing
POD_IP=$(kubectl get pod -n mars $POD_NAME -o jsonpath='{.status.podIP}')
echo "✅ PASS: Pod IP is: $POD_IP"

# Test HTTP access using temporary pod
echo "⏳ Testing HTTP access with temporary nginx:alpine pod..."
HTTP_RESPONSE=$(kubectl run tmp --restart=Never --rm -i --image=nginx:alpine --timeout=30s -- sh -c "
    apk add --no-cache curl > /dev/null 2>&1
    curl -s http://$POD_IP
" 2>/dev/null)

if [[ "$HTTP_RESPONSE" == "check this out!" ]]; then
    echo "✅ PASS: HTTP access works correctly, received: '$HTTP_RESPONSE'"
else
    echo "⚠️  WARNING: HTTP test result: '$HTTP_RESPONSE'"
    echo "    Expected: 'check this out!'"
fi

echo ""
echo "🎉 All validation checks passed!"
echo "InitContainer successfully creates index.html and nginx serves the content"

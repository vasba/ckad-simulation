#!/bin/bash

# Validation script for Question 24 - Service misconfiguration
echo "=== Validating Question 24: Service misconfiguration ==="

# Check if the mars namespace exists
if ! kubectl get namespace mars &>/dev/null; then
    echo "❌ FAIL: Namespace 'mars' not found"
    exit 1
fi

echo "✅ PASS: Namespace 'mars' exists"

# Check if the deployment exists and is ready
if ! kubectl get deployment manager-api-deployment -n mars &>/dev/null; then
    echo "❌ FAIL: Deployment 'manager-api-deployment' not found in namespace 'mars'"
    exit 1
fi

echo "✅ PASS: Deployment 'manager-api-deployment' exists"

# Check if deployment has correct number of replicas ready
READY_REPLICAS=$(kubectl get deployment manager-api-deployment -n mars -o jsonpath='{.status.readyReplicas}')
if [[ "$READY_REPLICAS" != "4" ]]; then
    echo "❌ FAIL: Expected 4 ready replicas, found: $READY_REPLICAS"
    exit 1
fi

echo "✅ PASS: Deployment has 4 ready replicas"

# Check if the service exists
if ! kubectl get service manager-api-svc -n mars &>/dev/null; then
    echo "❌ FAIL: Service 'manager-api-svc' not found in namespace 'mars'"
    exit 1
fi

echo "✅ PASS: Service 'manager-api-svc' exists"

# Check if service selector is correct (should be fixed)
SERVICE_SELECTOR=$(kubectl get service manager-api-svc -n mars -o jsonpath='{.spec.selector.id}')
if [[ "$SERVICE_SELECTOR" != "manager-api-pod" ]]; then
    echo "❌ FAIL: Service selector should be 'manager-api-pod', found: '$SERVICE_SELECTOR'"
    echo "    This indicates the misconfiguration hasn't been fixed yet"
    echo "    Student needs to edit the service and change selector from 'manager-api-deployment' to 'manager-api-pod'"
    exit 1
fi

echo "✅ PASS: Service selector correctly points to 'manager-api-pod'"

# Check if service has endpoints
ENDPOINTS=$(kubectl get endpoints manager-api-svc -n mars -o jsonpath='{.subsets[0].addresses}')
if [[ -z "$ENDPOINTS" ]]; then
    echo "❌ FAIL: Service has no endpoints - pods not being selected"
    exit 1
fi

ENDPOINT_COUNT=$(kubectl get endpoints manager-api-svc -n mars -o jsonpath='{.subsets[0].addresses}' | grep -o '"ip":' | wc -l)
if [[ "$ENDPOINT_COUNT" != "4" ]]; then
    echo "❌ FAIL: Expected 4 endpoints, found: $ENDPOINT_COUNT"
    exit 1
fi

echo "✅ PASS: Service has 4 endpoints"

# Test connectivity from within the cluster
echo "⏳ Testing service connectivity..."
HTTP_RESPONSE=$(kubectl run tmp --restart=Never --rm -i --image=nginx:alpine --timeout=30s -n mars -- sh -c "
    apk add --no-cache curl > /dev/null 2>&1
    curl -m 10 -s -w '%{http_code}' manager-api-svc:4444 -o /dev/null
" 2>/dev/null)

if [[ "$HTTP_RESPONSE" == "200" ]]; then
    echo "✅ PASS: Service connectivity test successful (HTTP 200)"
else
    echo "⚠️  WARNING: Service connectivity test returned: $HTTP_RESPONSE (expected 200)"
    echo "    This might indicate the service is not working properly"
fi

# Test cross-namespace connectivity  
echo "⏳ Testing cross-namespace connectivity..."
HTTP_RESPONSE_CROSS=$(kubectl run tmp --restart=Never --rm -i --image=nginx:alpine --timeout=30s -- sh -c "
    apk add --no-cache curl > /dev/null 2>&1
    curl -m 10 -s -w '%{http_code}' manager-api-svc.mars:4444 -o /dev/null
" 2>/dev/null)

if [[ "$HTTP_RESPONSE_CROSS" == "200" ]]; then
    echo "✅ PASS: Cross-namespace connectivity test successful (HTTP 200)"
else
    echo "⚠️  WARNING: Cross-namespace connectivity test returned: $HTTP_RESPONSE_CROSS"
fi

echo ""
echo "🎉 All validation checks passed!"
echo "Service misconfiguration has been properly fixed"
echo "The selector now correctly points to the pod labels"

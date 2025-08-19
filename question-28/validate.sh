#!/bin/bash

# Validation script for Question 28 - Liveness Probe
echo "=== Validating Question 28: Liveness Probe ==="

# Check if the pluto namespace exists
if ! kubectl get namespace pluto &>/dev/null; then
    echo "❌ FAIL: Namespace 'pluto' not found"
    exit 1
fi

echo "✅ PASS: Namespace 'pluto' exists"

# Check if the deployment exists
if ! kubectl get deployment project-23-api -n pluto &>/dev/null; then
    echo "❌ FAIL: Deployment 'project-23-api' not found in namespace 'pluto'"
    exit 1
fi

echo "✅ PASS: Deployment 'project-23-api' exists"

# Check if deployment has 3 replicas ready
READY_REPLICAS=$(kubectl get deployment project-23-api -n pluto -o jsonpath='{.status.readyReplicas}')
if [[ "$READY_REPLICAS" != "3" ]]; then
    echo "❌ FAIL: Expected 3 ready replicas, found: $READY_REPLICAS"
    exit 1
fi

echo "✅ PASS: Deployment has 3 ready replicas"

# Check if the project-23-api-new.yaml file exists
if [[ ! -f "$HOME/ckad-simulation/28/project-23-api-new.yaml" ]]; then
    echo "❌ FAIL: File '$HOME/ckad-simulation/28/project-23-api-new.yaml' not found"
    echo "    Student needs to copy and modify the original file"
    exit 1
fi

echo "✅ PASS: Modified YAML file exists"

# Check if liveness probe is configured
LIVENESS_PROBE=$(kubectl get deployment project-23-api -n pluto -o jsonpath='{.spec.template.spec.containers[0].livenessProbe}')
if [[ -z "$LIVENESS_PROBE" || "$LIVENESS_PROBE" == "null" ]]; then
    echo "❌ FAIL: No liveness probe configured in deployment"
    exit 1
fi

echo "✅ PASS: Liveness probe is configured"

# Check if liveness probe uses tcpSocket
LIVENESS_TCP_SOCKET=$(kubectl get deployment project-23-api -n pluto -o jsonpath='{.spec.template.spec.containers[0].livenessProbe.tcpSocket}')
if [[ -z "$LIVENESS_TCP_SOCKET" || "$LIVENESS_TCP_SOCKET" == "null" ]]; then
    echo "❌ FAIL: Liveness probe should use tcpSocket"
    exit 1
fi

echo "✅ PASS: Liveness probe uses tcpSocket"

# Check if tcpSocket port is configured (80 or any named port)
LIVENESS_PORT=$(kubectl get deployment project-23-api -n pluto -o jsonpath='{.spec.template.spec.containers[0].livenessProbe.tcpSocket.port}')
if [[ -z "$LIVENESS_PORT" ]]; then
    echo "❌ FAIL: Liveness probe tcpSocket port is not configured"
    exit 1
fi

# If it's a numeric port, check if it's 80
if [[ "$LIVENESS_PORT" =~ ^[0-9]+$ ]]; then
    if [[ "$LIVENESS_PORT" != "80" ]]; then
        echo "❌ FAIL: Liveness probe tcpSocket port should be 80, found: $LIVENESS_PORT"
        exit 1
    fi
    echo "✅ PASS: Liveness probe tcpSocket port is 80"
else
    # It's a named port - validate it exists in container ports
    CONTAINER_PORTS=$(kubectl get deployment project-23-api -n pluto -o jsonpath='{.spec.template.spec.containers[0].ports[*].name}')
    if [[ ! " $CONTAINER_PORTS " =~ " $LIVENESS_PORT " ]]; then
        echo "❌ FAIL: Named port '$LIVENESS_PORT' not found in container ports. Available ports: $CONTAINER_PORTS"
        exit 1
    fi
    echo "✅ PASS: Liveness probe uses named port '$LIVENESS_PORT'"
fi

# Check initialDelaySeconds
INITIAL_DELAY=$(kubectl get deployment project-23-api -n pluto -o jsonpath='{.spec.template.spec.containers[0].livenessProbe.initialDelaySeconds}')
if [[ "$INITIAL_DELAY" != "10" ]]; then
    echo "❌ FAIL: Liveness probe initialDelaySeconds should be 10, found: $INITIAL_DELAY"
    exit 1
fi

echo "✅ PASS: Liveness probe initialDelaySeconds is 10"

# Check periodSeconds
PERIOD_SECONDS=$(kubectl get deployment project-23-api -n pluto -o jsonpath='{.spec.template.spec.containers[0].livenessProbe.periodSeconds}')
if [[ "$PERIOD_SECONDS" != "15" ]]; then
    echo "❌ FAIL: Liveness probe periodSeconds should be 15, found: $PERIOD_SECONDS"
    exit 1
fi

echo "✅ PASS: Liveness probe periodSeconds is 15"

# Test connectivity to ensure the pods are working
echo "⏳ Testing pod connectivity..."
POD_IP=$(kubectl get pods -n pluto -l app=project-23-api -o jsonpath='{.items[0].status.podIP}')
if [[ -n "$POD_IP" ]]; then
    HTTP_RESPONSE=$(kubectl run tmp --restart=Never --rm -i --image=nginx:alpine --timeout=30s -- sh -c "
        curl -m 10 -s -w '%{http_code}' http://$POD_IP -o /dev/null
    " 2>/dev/null)
    
    if [[ "$HTTP_RESPONSE" == "200" ]]; then
        echo "✅ PASS: Pod connectivity test successful (HTTP 200)"
    else
        echo "⚠️  WARNING: Pod connectivity test returned: $HTTP_RESPONSE"
    fi
fi

# Show liveness probe details from a running pod
POD_NAME=$(kubectl get pods -n pluto -l app=project-23-api -o jsonpath='{.items[0].metadata.name}')
if [[ -n "$POD_NAME" ]]; then
    echo ""
    echo "📋 Liveness probe configuration on pod $POD_NAME:"
    kubectl -n pluto describe pod $POD_NAME | grep -A2 "Liveness:" || echo "  No liveness probe info found"
fi

echo ""
echo "🎉 All validation checks passed!"
echo "Liveness probe has been successfully configured"

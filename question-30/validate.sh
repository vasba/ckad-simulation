#!/bin/bash

echo "=== Validating Question 30 Solution ==="
echo ""

# Check if namespace exists
echo "1. Checking namespace 'earth'..."
if kubectl get namespace earth >/dev/null 2>&1; then
    echo "   ✅ Namespace 'earth' exists"
else
    echo "   ❌ Namespace 'earth' not found"
    exit 1
fi

# Check deployment 'holy'
echo ""
echo "2. Checking deployment 'holy'..."
if kubectl get deployment holy -n earth >/dev/null 2>&1; then
    echo "   ✅ Deployment 'holy' exists"
    
    # Check replicas and readiness
    DESIRED_REPLICAS=$(kubectl get deployment holy -n earth -o jsonpath='{.spec.replicas}')
    READY_REPLICAS=$(kubectl get deployment holy -n earth -o jsonpath='{.status.readyReplicas}')
    AVAILABLE_REPLICAS=$(kubectl get deployment holy -n earth -o jsonpath='{.status.availableReplicas}')
    
    echo "   📊 Replicas: Ready($READY_REPLICAS)/Available($AVAILABLE_REPLICAS)/Desired($DESIRED_REPLICAS)"
    
    if [ "$READY_REPLICAS" = "$DESIRED_REPLICAS" ] && [ "$AVAILABLE_REPLICAS" = "$DESIRED_REPLICAS" ]; then
        echo "   ✅ All pods are ready and available"
    else
        echo "   ❌ Not all pods are ready - this indicates the problem may not be fixed"
        echo "   🔍 Pod status details:"
        kubectl get pods -n earth -l app=holy
    fi
    
    # Check readiness probe configuration
    echo "   🔍 Checking readiness probe configuration:"
    READINESS_PORT=$(kubectl get deployment holy -n earth -o jsonpath='{.spec.template.spec.containers[0].readinessProbe.httpGet.port}')
    echo "   🚑 Readiness probe port: $READINESS_PORT"
    
    if [ "$READINESS_PORT" = "80" ]; then
        echo "   ✅ Readiness probe uses correct port (80)"
    elif [ "$READINESS_PORT" = "82" ]; then
        echo "   ❌ Readiness probe uses incorrect port (82) - this is the problem!"
    else
        echo "   ⚠️  Readiness probe port: $READINESS_PORT"
    fi
else
    echo "   ❌ Deployment 'holy' not found"
    exit 1
fi

# Check service 'holy-srv'
echo ""
echo "3. Checking service 'holy-srv'..."
if kubectl get service holy-srv -n earth >/dev/null 2>&1; then
    echo "   ✅ Service 'holy-srv' exists"
    
    # Check service details
    TYPE=$(kubectl get service holy-srv -n earth -o jsonpath='{.spec.type}')
    PORT=$(kubectl get service holy-srv -n earth -o jsonpath='{.spec.ports[0].port}')
    TARGET_PORT=$(kubectl get service holy-srv -n earth -o jsonpath='{.spec.ports[0].targetPort}')
    
    echo "   🔧 Type: $TYPE, Port: $PORT -> Target: $TARGET_PORT"
    
    # Check endpoints
    echo "   🎯 Checking service endpoints:"
    ENDPOINTS=$(kubectl get endpoints holy-srv -n earth -o jsonpath='{.subsets[*].addresses[*].ip}' 2>/dev/null)
    if [ -n "$ENDPOINTS" ]; then
        ENDPOINT_COUNT=$(echo $ENDPOINTS | wc -w)
        echo "   ✅ Service has $ENDPOINT_COUNT endpoint(s): $ENDPOINTS"
    else
        echo "   ❌ Service has no endpoints - pods are not ready"
    fi
else
    echo "   ❌ Service 'holy-srv' not found"
    exit 1
fi

# Check ticket.txt file
echo ""
echo "4. Checking ticket.txt file..."
if [ -f "ticket.txt" ]; then
    echo "   ✅ File ticket.txt exists"
    
    echo "   📄 File contents:"
    echo "   $(cat ticket.txt)"
    
    # Check if the file mentions the key issue
    if grep -qi "readiness\|probe\|port.*82\|port.*80" ticket.txt; then
        echo "   ✅ File mentions readiness probe or port issue"
    else
        echo "   ⚠️  File should explain the readiness probe port issue"
    fi
else
    echo "   ❌ File ticket.txt not found"
    exit 1
fi

# Test service connectivity (if endpoints exist)
echo ""
echo "5. Testing service connectivity..."
if [ -n "$ENDPOINTS" ]; then
    echo "   🧪 Testing service connectivity..."
    
    # Get service IP
    SERVICE_IP=$(kubectl get service holy-srv -n earth -o jsonpath='{.spec.clusterIP}')
    echo "   🌐 Service IP: $SERVICE_IP"
    
    # Test connectivity
    if kubectl run test-connectivity --restart=Never --rm -i --image=busybox:1.35 -- wget -qO- --timeout=5 $SERVICE_IP 2>/dev/null | grep -i "welcome to nginx" >/dev/null; then
        echo "   ✅ Service connectivity successful - problem is fixed!"
    else
        echo "   ⚠️  Service connectivity failed - checking further..."
        # Try direct pod access
        POD_IP=$(kubectl get pods -n earth -l app=holy -o jsonpath='{.items[0].status.podIP}' 2>/dev/null)
        if [ -n "$POD_IP" ]; then
            echo "   🔍 Testing direct pod connectivity to $POD_IP..."
            if kubectl run test-pod-direct --restart=Never --rm -i --image=busybox:1.35 -- wget -qO- --timeout=5 $POD_IP 2>/dev/null | grep -i "welcome to nginx" >/dev/null; then
                echo "   ✅ Direct pod connectivity works - service/endpoint issue"
            else
                echo "   ❌ Direct pod connectivity also fails"
            fi
        fi
    fi
else
    echo "   ⚠️  Skipping connectivity test - no service endpoints available"
fi

echo ""
echo "6. Diagnostic Information:"
echo "   📋 Pod details:"
kubectl get pods -n earth -l app=holy -o wide

echo ""
echo "   🔍 Service endpoints:"
kubectl get endpoints holy-srv -n earth

echo ""
echo "   📊 Deployment status:"
kubectl describe deployment holy -n earth | grep -A 5 "Conditions:"

echo ""
echo "=== Validation Summary ==="
if [ -n "$ENDPOINTS" ] && [ "$READINESS_PORT" = "80" ]; then
    echo "✅ Question 30 appears to be solved correctly!"
    echo "   - Readiness probe uses correct port (80)"
    echo "   - Service has endpoints"
    echo "   - Ticket file exists"
elif [ "$READINESS_PORT" = "82" ]; then
    echo "❌ Question 30 not yet solved:"
    echo "   - Readiness probe still uses wrong port (82)"
    echo "   - This prevents pods from becoming ready"
    echo "   - Service has no endpoints to route traffic to"
else
    echo "⚠️  Question 30 status unclear - please verify the solution"
fi

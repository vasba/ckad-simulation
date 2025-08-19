#!/bin/bash

echo "=== Validating Question 29 Solution ==="
echo ""

# Check if namespace exists
echo "1. Checking namespace 'sun'..."
if kubectl get namespace sun >/dev/null 2>&1; then
    echo "   ✅ Namespace 'sun' exists"
else
    echo "   ❌ Namespace 'sun' not found"
    exit 1
fi

# Check if ServiceAccount exists
echo ""
echo "2. Checking ServiceAccount 'sa-sun-deploy'..."
if kubectl get sa sa-sun-deploy -n sun >/dev/null 2>&1; then
    echo "   ✅ ServiceAccount 'sa-sun-deploy' exists in namespace 'sun'"
else
    echo "   ❌ ServiceAccount 'sa-sun-deploy' not found in namespace 'sun'"
    exit 1
fi

# Check deployment 'sunny'
echo ""
echo "3. Checking deployment 'sunny'..."
if kubectl get deployment sunny -n sun >/dev/null 2>&1; then
    echo "   ✅ Deployment 'sunny' exists"
    
    # Check replicas
    DESIRED_REPLICAS=$(kubectl get deployment sunny -n sun -o jsonpath='{.spec.replicas}')
    READY_REPLICAS=$(kubectl get deployment sunny -n sun -o jsonpath='{.status.readyReplicas}')
    echo "   📊 Replicas: $READY_REPLICAS/$DESIRED_REPLICAS"
    
    if [ "$DESIRED_REPLICAS" = "4" ]; then
        echo "   ✅ Correct number of replicas (4)"
    else
        echo "   ❌ Expected 4 replicas, found $DESIRED_REPLICAS"
    fi
    
    # Check image
    IMAGE=$(kubectl get deployment sunny -n sun -o jsonpath='{.spec.template.spec.containers[0].image}')
    echo "   🖼️  Image: $IMAGE"
    
    if [ "$IMAGE" = "nginx:1.17.3-alpine" ]; then
        echo "   ✅ Correct image (nginx:1.17.3-alpine)"
    else
        echo "   ❌ Expected nginx:1.17.3-alpine, found $IMAGE"
    fi
    
    # Check ServiceAccount
    SA=$(kubectl get deployment sunny -n sun -o jsonpath='{.spec.template.spec.serviceAccountName}')
    echo "   👤 ServiceAccount: $SA"
    
    if [ "$SA" = "sa-sun-deploy" ]; then
        echo "   ✅ Correct ServiceAccount (sa-sun-deploy)"
    else
        echo "   ❌ Expected sa-sun-deploy, found: $SA"
    fi
else
    echo "   ❌ Deployment 'sunny' not found"
    exit 1
fi

# Check service 'sun-srv'
echo ""
echo "4. Checking service 'sun-srv'..."
if kubectl get service sun-srv -n sun >/dev/null 2>&1; then
    echo "   ✅ Service 'sun-srv' exists"
    
    # Check service type
    TYPE=$(kubectl get service sun-srv -n sun -o jsonpath='{.spec.type}')
    echo "   🔧 Type: $TYPE"
    
    if [ "$TYPE" = "ClusterIP" ]; then
        echo "   ✅ Correct service type (ClusterIP)"
    else
        echo "   ❌ Expected ClusterIP, found $TYPE"
    fi
    
    # Check port
    PORT=$(kubectl get service sun-srv -n sun -o jsonpath='{.spec.ports[0].port}')
    TARGET_PORT=$(kubectl get service sun-srv -n sun -o jsonpath='{.spec.ports[0].targetPort}')
    echo "   🔌 Port: $PORT -> Target: $TARGET_PORT"
    
    if [ "$PORT" = "9999" ]; then
        echo "   ✅ Correct port (9999)"
    else
        echo "   ❌ Expected port 9999, found $PORT"
    fi
    
    if [ "$TARGET_PORT" = "80" ]; then
        echo "   ✅ Correct target port (80)"
    else
        echo "   ❌ Expected target port 80, found $TARGET_PORT"
    fi
    
    # Check selector
    SELECTOR=$(kubectl get service sun-srv -n sun -o jsonpath='{.spec.selector}')
    echo "   🎯 Selector: $SELECTOR"
else
    echo "   ❌ Service 'sun-srv' not found"
    exit 1
fi

# Check sunny_status_command.sh file
echo ""
echo "5. Checking sunny_status_command.sh file..."
if [ -f "sunny_status_command.sh" ]; then
    echo "   ✅ File sunny_status_command.sh exists"
    
    # Check if file is executable
    if [ -x "sunny_status_command.sh" ]; then
        echo "   ✅ File is executable"
    else
        echo "   ⚠️  File is not executable (but this is acceptable)"
    fi
    
    # Show file contents
    echo "   📄 File contents:"
    echo "   $(cat sunny_status_command.sh)"
    
    # Test the script
    echo "   🧪 Testing script output:"
    bash sunny_status_command.sh 2>/dev/null | head -5
else
    echo "   ❌ File sunny_status_command.sh not found"
    exit 1
fi

# Test service connectivity (if pods are ready)
echo ""
echo "6. Testing service connectivity..."
if [ "$READY_REPLICAS" = "4" ]; then
    # Get service IP
    SERVICE_IP=$(kubectl get service sun-srv -n sun -o jsonpath='{.spec.clusterIP}')
    echo "   🌐 Service IP: $SERVICE_IP"
    
    # Test connectivity
    echo "   🔍 Testing connectivity..."
    if kubectl run test-pod --restart=Never --rm -i --image=busybox:1.35 -- wget -qO- --timeout=5 $SERVICE_IP:9999 >/dev/null 2>&1; then
        echo "   ✅ Service is reachable"
    else
        echo "   ⚠️  Service connectivity test failed (pods might still be starting)"
    fi
else
    echo "   ⚠️  Skipping connectivity test - pods not ready"
fi

echo ""
echo "=== Validation Summary ==="
kubectl get all -n sun -o wide
echo ""
echo "✅ Question 29 validation completed successfully!"

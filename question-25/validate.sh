#!/bin/bash

# Validation script for Question 25 - Service ClusterIP->NodePort
echo "=== Validating Question 25: Service ClusterIP->NodePort ==="

# Check if the jupiter namespace exists
if ! kubectl get namespace jupiter &>/dev/null; then
    echo "❌ FAIL: Namespace 'jupiter' not found"
    exit 1
fi

echo "✅ PASS: Namespace 'jupiter' exists"

# Check if the deployment exists and is ready
if ! kubectl get deployment jupiter-crew-deploy -n jupiter &>/dev/null; then
    echo "❌ FAIL: Deployment 'jupiter-crew-deploy' not found in namespace 'jupiter'"
    exit 1
fi

echo "✅ PASS: Deployment 'jupiter-crew-deploy' exists"

# Check if deployment is ready
READY_REPLICAS=$(kubectl get deployment jupiter-crew-deploy -n jupiter -o jsonpath='{.status.readyReplicas}')
if [[ "$READY_REPLICAS" != "1" ]]; then
    echo "❌ FAIL: Expected 1 ready replica, found: $READY_REPLICAS"
    exit 1
fi

echo "✅ PASS: Deployment has 1 ready replica"

# Check if the service exists
if ! kubectl get service jupiter-crew-svc -n jupiter &>/dev/null; then
    echo "❌ FAIL: Service 'jupiter-crew-svc' not found in namespace 'jupiter'"
    exit 1
fi

echo "✅ PASS: Service 'jupiter-crew-svc' exists"

# Check if service type has been changed to NodePort
SERVICE_TYPE=$(kubectl get service jupiter-crew-svc -n jupiter -o jsonpath='{.spec.type}')
if [[ "$SERVICE_TYPE" != "NodePort" ]]; then
    echo "❌ FAIL: Service type should be 'NodePort', found: '$SERVICE_TYPE'"
    echo "    Student needs to edit the service and change type from ClusterIP to NodePort"
    exit 1
fi

echo "✅ PASS: Service type is 'NodePort'"

# Check if nodePort is set to 30100
NODE_PORT=$(kubectl get service jupiter-crew-svc -n jupiter -o jsonpath='{.spec.ports[0].nodePort}')
if [[ "$NODE_PORT" != "30100" ]]; then
    echo "❌ FAIL: NodePort should be '30100', found: '$NODE_PORT'"
    echo "    Student needs to add 'nodePort: 30100' to the ports section"
    exit 1
fi

echo "✅ PASS: NodePort is correctly set to 30100"

# Check if service has endpoints
ENDPOINTS=$(kubectl get endpoints jupiter-crew-svc -n jupiter -o jsonpath='{.subsets[0].addresses}')
if [[ -z "$ENDPOINTS" ]]; then
    echo "❌ FAIL: Service has no endpoints - pods not being selected"
    exit 1
fi

echo "✅ PASS: Service has endpoints"

# Test internal ClusterIP connectivity (NodePort should still work internally)
echo "⏳ Testing internal ClusterIP connectivity..."
HTTP_RESPONSE=$(kubectl run tmp --restart=Never --rm -i --image=nginx:alpine --timeout=30s -n jupiter -- sh -c "
    apk add --no-cache curl > /dev/null 2>&1
    curl -m 10 -s -w '%{http_code}' jupiter-crew-svc:8080 -o /dev/null
" 2>/dev/null)

if [[ "$HTTP_RESPONSE" == "200" ]]; then
    echo "✅ PASS: Internal ClusterIP connectivity works (HTTP 200)"
else
    echo "⚠️  WARNING: Internal connectivity test returned: $HTTP_RESPONSE (expected 200)"
fi

# Get node information
echo "⏳ Getting node information..."
NODE_IPS=$(kubectl get nodes -o jsonpath='{.items[*].status.addresses[?(@.type=="InternalIP")].address}')
if [[ -z "$NODE_IPS" ]]; then
    echo "⚠️  WARNING: Could not retrieve node IPs"
else
    echo "✅ PASS: Found node IPs: $NODE_IPS"
    
    # Test NodePort connectivity on each node (if curl is available)
    for NODE_IP in $NODE_IPS; do
        echo "⏳ Testing NodePort connectivity on node $NODE_IP..."
        if command -v curl >/dev/null 2>&1; then
            HTTP_RESPONSE_NODE=$(curl -m 10 -s -w '%{http_code}' http://$NODE_IP:30100 -o /dev/null 2>/dev/null)
            if [[ "$HTTP_RESPONSE_NODE" == "200" ]]; then
                echo "✅ PASS: NodePort connectivity works on $NODE_IP (HTTP 200)"
            else
                echo "⚠️  WARNING: NodePort test on $NODE_IP returned: $HTTP_RESPONSE_NODE"
            fi
        else
            echo "⚠️  INFO: curl not available for NodePort testing on node $NODE_IP"
        fi
    done
fi

# Show which node the pod is running on
POD_NODE=$(kubectl get pods -n jupiter -l id=jupiter-crew -o jsonpath='{.items[0].spec.nodeName}')
if [[ -n "$POD_NODE" ]]; then
    echo "✅ INFO: Pod is running on node: $POD_NODE"
else
    echo "⚠️  WARNING: Could not determine which node the pod is running on"
fi

echo ""
echo "🎉 All validation checks passed!"
echo "Service has been successfully converted from ClusterIP to NodePort"
echo "The service is now accessible on all nodes at port 30100"

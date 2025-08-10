#!/bin/bash

# Validation script for Question 17 - Network Policy
echo "=== Validating Question 17: Network Policy ==="

# Check if venus namespace exists
if kubectl get namespace venus &>/dev/null; then
    echo "✅ PASS: venus namespace exists"
else
    echo "❌ FAIL: venus namespace not found"
    exit 1
fi

# Check if api deployment exists in venus namespace
if kubectl get deployment api -n venus &>/dev/null; then
    echo "✅ PASS: api deployment exists in venus namespace"
else
    echo "❌ FAIL: api deployment not found in venus namespace"
    exit 1
fi

# Check if frontend deployment exists in venus namespace
if kubectl get deployment frontend -n venus &>/dev/null; then
    echo "✅ PASS: frontend deployment exists in venus namespace"
else
    echo "❌ FAIL: frontend deployment not found in venus namespace"
    exit 1
fi

# Check if api service exists
if kubectl get service api -n venus &>/dev/null; then
    echo "✅ PASS: api service exists in venus namespace"
    
    # Check if api service is on correct port
    api_port=$(kubectl get service api -n venus -o jsonpath='{.spec.ports[0].port}')
    if [[ "$api_port" == "2222" ]]; then
        echo "✅ PASS: api service is exposed on correct port (2222)"
    else
        echo "❌ FAIL: api service is on wrong port ($api_port), expected 2222"
        exit 1
    fi
else
    echo "❌ FAIL: api service not found in venus namespace"
    exit 1
fi

# Check if frontend service exists
if kubectl get service frontend -n venus &>/dev/null; then
    echo "✅ PASS: frontend service exists in venus namespace"
    
    # Check if frontend service is on correct port
    frontend_port=$(kubectl get service frontend -n venus -o jsonpath='{.spec.ports[0].port}')
    if [[ "$frontend_port" == "80" ]]; then
        echo "✅ PASS: frontend service is exposed on correct port (80)"
    else
        echo "❌ FAIL: frontend service is on wrong port ($frontend_port), expected 80"
        exit 1
    fi
else
    echo "❌ FAIL: frontend service not found in venus namespace"
    exit 1
fi

# Check if np1 NetworkPolicy exists
if kubectl get networkpolicy np1 -n venus &>/dev/null; then
    echo "✅ PASS: np1 NetworkPolicy exists in venus namespace"
else
    echo "❌ FAIL: np1 NetworkPolicy not found in venus namespace"
    exit 1
fi

# Check if np1 NetworkPolicy targets frontend pods (id=frontend)
np1_selector=$(kubectl get networkpolicy np1 -n venus -o jsonpath='{.spec.podSelector.matchLabels.id}')
if [[ "$np1_selector" == "frontend" ]]; then
    echo "✅ PASS: np1 NetworkPolicy targets frontend pods (id=frontend)"
else
    echo "❌ FAIL: np1 NetworkPolicy does not target frontend pods (found selector: $np1_selector)"
    exit 1
fi

# Check if np1 NetworkPolicy has Egress policy type
policy_types=$(kubectl get networkpolicy np1 -n venus -o jsonpath='{.spec.policyTypes[*]}')
if [[ "$policy_types" == *"Egress"* ]]; then
    echo "✅ PASS: np1 NetworkPolicy has Egress policy type"
else
    echo "❌ FAIL: np1 NetworkPolicy does not have Egress policy type"
    exit 1
fi

# Check if np1 has egress rules
egress_rules=$(kubectl get networkpolicy np1 -n venus -o jsonpath='{.spec.egress}')
if [[ -n "$egress_rules" ]] && [[ "$egress_rules" != "null" ]]; then
    echo "✅ PASS: np1 NetworkPolicy has egress rules"
    
    # Check if egress rules allow traffic to api pods (id=api)
    api_egress=$(kubectl get networkpolicy np1 -n venus -o jsonpath='{.spec.egress[0].to[0].podSelector.matchLabels.id}')
    if [[ "$api_egress" == "api" ]]; then
        echo "✅ PASS: np1 allows egress to api pods (id=api)"
    else
        echo "❌ FAIL: np1 does not allow egress to api pods"
        exit 1
    fi
    
    # Check if DNS ports are allowed (port 53 UDP/TCP)
    dns_udp=$(kubectl get networkpolicy np1 -n venus -o jsonpath='{.spec.egress[1].ports[0].port}')
    dns_tcp=$(kubectl get networkpolicy np1 -n venus -o jsonpath='{.spec.egress[1].ports[1].port}')
    if [[ "$dns_udp" == "53" ]] && [[ "$dns_tcp" == "53" ]]; then
        echo "✅ PASS: np1 allows DNS traffic on port 53 (UDP/TCP)"
    else
        echo "❌ FAIL: np1 does not properly allow DNS traffic"
        exit 1
    fi
else
    echo "❌ FAIL: np1 NetworkPolicy does not have egress rules"
    exit 1
fi

# Check if deployments are ready
api_ready=$(kubectl get deployment api -n venus -o jsonpath='{.status.readyReplicas}')
frontend_ready=$(kubectl get deployment frontend -n venus -o jsonpath='{.status.readyReplicas}')

if [[ "$api_ready" -gt 0 ]]; then
    echo "✅ PASS: api deployment has ready replicas ($api_ready)"
else
    echo "⚠️  WARNING: api deployment has no ready replicas"
fi

if [[ "$frontend_ready" -gt 0 ]]; then
    echo "✅ PASS: frontend deployment has ready replicas ($frontend_ready)"
else
    echo "⚠️  WARNING: frontend deployment has no ready replicas"
fi

echo "🎉 All validations passed for Question 17!"

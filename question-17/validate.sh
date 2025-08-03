#!/bin/bash

# Validation script for Question 17 - Network Policy
echo "=== Validating Question 17: Network Policy ==="

# Check if frontend pod exists in sun namespace
if kubectl get pod frontend -n sun &>/dev/null; then
    echo "✅ PASS: frontend pod exists in sun namespace"
else
    echo "❌ FAIL: frontend pod not found in sun namespace"
    exit 1
fi

# Check if frontend pod is using correct image
pod_image=$(kubectl get pod frontend -n sun -o jsonpath='{.spec.containers[0].image}')
if [[ "$pod_image" == "nginx:1.21.1-alpine" ]]; then
    echo "✅ PASS: frontend pod is using correct image (nginx:1.21.1-alpine)"
else
    echo "❌ FAIL: frontend pod is using wrong image ($pod_image), expected nginx:1.21.1-alpine"
    exit 1
fi

# Check if frontend pod has correct label
pod_label=$(kubectl get pod frontend -n sun -o jsonpath='{.metadata.labels.app}')
if [[ "$pod_label" == "frontend" ]]; then
    echo "✅ PASS: frontend pod has correct label (app=frontend)"
else
    echo "❌ FAIL: frontend pod has wrong label ($pod_label), expected app=frontend"
    exit 1
fi

# Check if frontend-deny NetworkPolicy exists
if kubectl get networkpolicy frontend-deny -n sun &>/dev/null; then
    echo "✅ PASS: frontend-deny NetworkPolicy exists in sun namespace"
else
    echo "❌ FAIL: frontend-deny NetworkPolicy not found in sun namespace"
    exit 1
fi

# Check if frontend-deny NetworkPolicy targets frontend pod
deny_selector=$(kubectl get networkpolicy frontend-deny -n sun -o jsonpath='{.spec.podSelector.matchLabels.app}')
if [[ "$deny_selector" == "frontend" ]]; then
    echo "✅ PASS: frontend-deny NetworkPolicy targets frontend pod"
else
    echo "❌ FAIL: frontend-deny NetworkPolicy does not target frontend pod"
    exit 1
fi

# Check if frontend-deny NetworkPolicy has both Ingress and Egress policy types
policy_types=$(kubectl get networkpolicy frontend-deny -n sun -o jsonpath='{.spec.policyTypes[*]}')
if [[ "$policy_types" == *"Ingress"* ]] && [[ "$policy_types" == *"Egress"* ]]; then
    echo "✅ PASS: frontend-deny NetworkPolicy has both Ingress and Egress policy types"
else
    echo "❌ FAIL: frontend-deny NetworkPolicy does not have both Ingress and Egress policy types"
    exit 1
fi

# Check if frontend-netpol NetworkPolicy exists
if kubectl get networkpolicy frontend-netpol -n sun &>/dev/null; then
    echo "✅ PASS: frontend-netpol NetworkPolicy exists in sun namespace"
else
    echo "❌ FAIL: frontend-netpol NetworkPolicy not found in sun namespace"
    exit 1
fi

# Check if frontend-netpol NetworkPolicy targets frontend pod
netpol_selector=$(kubectl get networkpolicy frontend-netpol -n sun -o jsonpath='{.spec.podSelector.matchLabels.app}')
if [[ "$netpol_selector" == "frontend" ]]; then
    echo "✅ PASS: frontend-netpol NetworkPolicy targets frontend pod"
else
    echo "❌ FAIL: frontend-netpol NetworkPolicy does not target frontend pod"
    exit 1
fi

# Check if frontend-netpol has ingress rules
ingress_rules=$(kubectl get networkpolicy frontend-netpol -n sun -o jsonpath='{.spec.ingress}')
if [[ -n "$ingress_rules" ]] && [[ "$ingress_rules" != "null" ]]; then
    echo "✅ PASS: frontend-netpol NetworkPolicy has ingress rules"
else
    echo "❌ FAIL: frontend-netpol NetworkPolicy does not have ingress rules"
    exit 1
fi

# Check if frontend-netpol has egress rules
egress_rules=$(kubectl get networkpolicy frontend-netpol -n sun -o jsonpath='{.spec.egress}')
if [[ -n "$egress_rules" ]] && [[ "$egress_rules" != "null" ]]; then
    echo "✅ PASS: frontend-netpol NetworkPolicy has egress rules"
else
    echo "❌ FAIL: frontend-netpol NetworkPolicy does not have egress rules"
    exit 1
fi

# Check if pod is running
pod_status=$(kubectl get pod frontend -n sun -o jsonpath='{.status.phase}')
if [[ "$pod_status" == "Running" ]]; then
    echo "✅ PASS: frontend pod is running"
else
    echo "⚠️  WARNING: frontend pod is not running (status: $pod_status)"
fi

echo "🎉 All validations passed for Question 17!"

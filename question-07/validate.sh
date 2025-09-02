#!/bin/bash

# Validation script for Question 7 - Pods, Namespaces
echo "=== Validating Question 7: Pods, Namespaces ==="

# Check if webserver.yaml file exists
if [[ -f "webserver.yaml" ]]; then
    echo "✅ PASS: webserver.yaml file exists"
else
    echo "❌ FAIL: webserver.yaml file not found"
    exit 1
fi

# Check if webserver.yaml specifies neptune namespace
namespace=$(grep -E "^\s*namespace:" webserver.yaml | awk '{print $2}' | tr -d '"')
if [[ "$namespace" == "neptune" ]]; then
    echo "✅ PASS: webserver.yaml specifies neptune namespace"
else
    echo "❌ FAIL: webserver.yaml does not specify neptune namespace, found: $namespace"
    exit 1
fi

# Check if Pod exists in neptune namespace with my-happy-shop label
pod_with_label=$(kubectl -n neptune get pods -l system=my-happy-shop --no-headers 2>/dev/null | wc -l)
if [[ "$pod_with_label" -gt 0 ]]; then
    echo "✅ PASS: Pod with label 'system=my-happy-shop' exists in neptune namespace"
else
    echo "❌ FAIL: No pod with label 'system=my-happy-shop' found in neptune namespace"
    
fi

# Check if there are no pods with my-happy-shop label in saturn namespace
pod_in_saturn=$(kubectl -n saturn get pods -l system=my-happy-shop --no-headers 2>/dev/null | wc -l)
if [[ "$pod_in_saturn" -eq 0 ]]; then
    echo "✅ PASS: No pod with label 'system=my-happy-shop' in saturn namespace (successfully moved)"
else
    echo "❌ FAIL: Pod with label 'system=my-happy-shop' still exists in saturn namespace"
    exit 1
fi

echo "🎉 All validations passed for Question 7!"

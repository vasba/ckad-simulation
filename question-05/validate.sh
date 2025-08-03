#!/bin/bash

# Validation script for Question 5 - ServiceAccount, Secret
echo "=== Validating Question 5: ServiceAccount, Secret ==="

# Check if neptune-sa-v2 service account exists
if kubectl get sa neptune-sa-v2 -n neptune &>/dev/null; then
    echo "✅ PASS: neptune-sa-v2 service account exists"
else
    echo "❌ FAIL: neptune-sa-v2 service account not found"
    exit 1
fi

# Check if neptune-secret-1 exists
if kubectl get secret neptune-secret-1 -n neptune &>/dev/null; then
    echo "✅ PASS: neptune-secret-1 exists"
else
    echo "❌ FAIL: neptune-secret-1 not found"
    exit 1
fi

# Check if secret has correct annotation
annotation=$(kubectl get secret neptune-secret-1 -n neptune -o jsonpath='{.metadata.annotations.kubernetes\.io/service-account\.name}')
if [[ "$annotation" == "neptune-sa-v2" ]]; then
    echo "✅ PASS: neptune-secret-1 has correct annotation (kubernetes.io/service-account.name: neptune-sa-v2)"
else
    echo "❌ FAIL: neptune-secret-1 missing correct annotation, found: $annotation"
    exit 1
fi

# Check if token file exists
if [[ -f "token" ]]; then
    echo "✅ PASS: token file exists"
    
    # Check if token file is not empty
    if [[ -s "token" ]]; then
        echo "✅ PASS: token file is not empty"
    else
        echo "❌ FAIL: token file is empty"
        exit 1
    fi
else
    echo "❌ FAIL: token file not found"
    exit 1
fi

# Verify the token can be extracted from the secret
secret_token=$(kubectl get secret neptune-secret-1 -n neptune -o jsonpath="{.data.token}" | base64 -d)
file_token=$(cat token)

if [[ "$secret_token" == "$file_token" ]]; then
    echo "✅ PASS: token file contains correct token from secret"
else
    echo "❌ FAIL: token file does not match secret token"
    exit 1
fi

echo "🎉 All validations passed for Question 5!"

#!/bin/bash

# Validation script for Question 13 - Storage, StorageClass, PVC
echo "=== Validating Question 13: Storage, StorageClass, PVC ==="

# Check if StorageClass moon-retain exists
if kubectl get storageclass moon-retain &>/dev/null; then
    echo "✅ PASS: StorageClass moon-retain exists"
else
    echo "❌ FAIL: StorageClass moon-retain not found"
    exit 1
fi

# Check StorageClass specifications
provisioner=$(kubectl get storageclass moon-retain -o jsonpath='{.provisioner}')
if [[ "$provisioner" == "moon-retainer" ]]; then
    echo "✅ PASS: StorageClass has correct provisioner (moon-retainer)"
else
    echo "❌ FAIL: StorageClass has wrong provisioner ($provisioner), expected moon-retainer"
    exit 1
fi

reclaim_policy=$(kubectl get storageclass moon-retain -o jsonpath='{.reclaimPolicy}')
if [[ "$reclaim_policy" == "Retain" ]]; then
    echo "✅ PASS: StorageClass has correct reclaimPolicy (Retain)"
else
    echo "❌ FAIL: StorageClass has wrong reclaimPolicy ($reclaim_policy), expected Retain"
    exit 1
fi

# Check if PVC moon-pvc-126 exists in moon namespace
if kubectl get pvc moon-pvc-126 -n moon &>/dev/null; then
    echo "✅ PASS: PVC moon-pvc-126 exists in moon namespace"
else
    echo "❌ FAIL: PVC moon-pvc-126 not found in moon namespace"
    exit 1
fi

# Check PVC specifications
pvc_storage=$(kubectl get pvc moon-pvc-126 -n moon -o jsonpath='{.spec.resources.requests.storage}')
if [[ "$pvc_storage" == "3Gi" ]]; then
    echo "✅ PASS: PVC requests correct storage (3Gi)"
else
    echo "❌ FAIL: PVC requests wrong storage ($pvc_storage), expected 3Gi"
    exit 1
fi

pvc_storage_class=$(kubectl get pvc moon-pvc-126 -n moon -o jsonpath='{.spec.storageClassName}')
if [[ "$pvc_storage_class" == "moon-retain" ]]; then
    echo "✅ PASS: PVC uses correct StorageClass (moon-retain)"
else
    echo "❌ FAIL: PVC uses wrong StorageClass ($pvc_storage_class), expected moon-retain"
    exit 1
fi

pvc_access_mode=$(kubectl get pvc moon-pvc-126 -n moon -o jsonpath='{.spec.accessModes[0]}')
if [[ "$pvc_access_mode" == "ReadWriteOnce" ]]; then
    echo "✅ PASS: PVC has correct access mode (ReadWriteOnce)"
else
    echo "❌ FAIL: PVC has wrong access mode ($pvc_access_mode), expected ReadWriteOnce"
    exit 1
fi

# Check PVC status (might be Pending due to missing provisioner)
pvc_status=$(kubectl get pvc moon-pvc-126 -n moon -o jsonpath='{.status.phase}')
if [[ "$pvc_status" == "Bound" ]]; then
    echo "✅ PASS: PVC is bound"
elif [[ "$pvc_status" == "Pending" ]]; then
    echo "⚠️  WARNING: PVC is pending (expected if moon-retainer provisioner is not available)"
else
    echo "❌ FAIL: PVC has unexpected status: $pvc_status"
    exit 1
fi

echo "🎉 All validations passed for Question 13!"

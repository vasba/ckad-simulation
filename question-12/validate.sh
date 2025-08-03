#!/bin/bash

# Validation script for Question 12 - Storage, PV, PVC, Pod volume
echo "=== Validating Question 12: Storage, PV, PVC, Pod volume ==="

# Check if PV earth-project-earthflower-pv exists
if kubectl get pv earth-project-earthflower-pv &>/dev/null; then
    echo "✅ PASS: PV earth-project-earthflower-pv exists"
else
    echo "❌ FAIL: PV earth-project-earthflower-pv not found"
    exit 1
fi

# Check PV specifications
pv_capacity=$(kubectl get pv earth-project-earthflower-pv -o jsonpath='{.spec.capacity.storage}')
if [[ "$pv_capacity" == "2Gi" ]]; then
    echo "✅ PASS: PV has correct capacity (2Gi)"
else
    echo "❌ FAIL: PV has wrong capacity ($pv_capacity), expected 2Gi"
    exit 1
fi

pv_access_mode=$(kubectl get pv earth-project-earthflower-pv -o jsonpath='{.spec.accessModes[0]}')
if [[ "$pv_access_mode" == "ReadWriteOnce" ]]; then
    echo "✅ PASS: PV has correct access mode (ReadWriteOnce)"
else
    echo "❌ FAIL: PV has wrong access mode ($pv_access_mode), expected ReadWriteOnce"
    exit 1
fi

pv_path=$(kubectl get pv earth-project-earthflower-pv -o jsonpath='{.spec.hostPath.path}')
if [[ "$pv_path" == "/Volumes/Data" ]]; then
    echo "✅ PASS: PV has correct hostPath (/Volumes/Data)"
else
    echo "❌ FAIL: PV has wrong hostPath ($pv_path), expected /Volumes/Data"
    exit 1
fi

# Check if PVC earth-project-earthflower-pvc exists in earth namespace
if kubectl get pvc earth-project-earthflower-pvc -n earth &>/dev/null; then
    echo "✅ PASS: PVC earth-project-earthflower-pvc exists in earth namespace"
else
    echo "❌ FAIL: PVC earth-project-earthflower-pvc not found in earth namespace"
    exit 1
fi

# Check PVC specifications
pvc_storage=$(kubectl get pvc earth-project-earthflower-pvc -n earth -o jsonpath='{.spec.resources.requests.storage}')
if [[ "$pvc_storage" == "2Gi" ]]; then
    echo "✅ PASS: PVC requests correct storage (2Gi)"
else
    echo "❌ FAIL: PVC requests wrong storage ($pvc_storage), expected 2Gi"
    exit 1
fi

pvc_access_mode=$(kubectl get pvc earth-project-earthflower-pvc -n earth -o jsonpath='{.spec.accessModes[0]}')
if [[ "$pvc_access_mode" == "ReadWriteOnce" ]]; then
    echo "✅ PASS: PVC has correct access mode (ReadWriteOnce)"
else
    echo "❌ FAIL: PVC has wrong access mode ($pvc_access_mode), expected ReadWriteOnce"
    exit 1
fi

# Check if PVC is bound
pvc_status=$(kubectl get pvc earth-project-earthflower-pvc -n earth -o jsonpath='{.status.phase}')
if [[ "$pvc_status" == "Bound" ]]; then
    echo "✅ PASS: PVC is bound to PV"
else
    echo "❌ FAIL: PVC is not bound (status: $pvc_status)"
    exit 1
fi

# Check if Pod earth-project exists in earth namespace
if kubectl get pod earth-project -n earth &>/dev/null; then
    echo "✅ PASS: Pod earth-project exists in earth namespace"
else
    echo "❌ FAIL: Pod earth-project not found in earth namespace"
    exit 1
fi

# Check if Pod uses the PVC
pod_pvc=$(kubectl get pod earth-project -n earth -o jsonpath='{.spec.volumes[*].persistentVolumeClaim.claimName}')
if [[ "$pod_pvc" == *"earth-project-earthflower-pvc"* ]]; then
    echo "✅ PASS: Pod uses the correct PVC"
else
    echo "❌ FAIL: Pod does not use the correct PVC"
    exit 1
fi

# Check if Pod has volume mount
volume_mount=$(kubectl get pod earth-project -n earth -o jsonpath='{.spec.containers[0].volumeMounts[*].mountPath}')
if [[ -n "$volume_mount" ]]; then
    echo "✅ PASS: Pod has volume mount configured ($volume_mount)"
else
    echo "❌ FAIL: Pod does not have volume mount configured"
    exit 1
fi

echo "🎉 All validations passed for Question 12!"

#!/bin/bash

# Validation script for Question 16 - Logging sidecar
echo "=== Validating Question 16: Logging sidecar ==="

# Check if cleaner deployment exists in mercury namespace
if kubectl get deployment cleaner -n mercury &>/dev/null; then
    echo "✅ PASS: cleaner deployment exists in mercury namespace"
else
    echo "❌ FAIL: cleaner deployment not found in mercury namespace"
    exit 1
fi

# Check if deployment is running successfully
ready_replicas=$(kubectl get deployment cleaner -n mercury -o jsonpath='{.status.readyReplicas}')
desired_replicas=$(kubectl get deployment cleaner -n mercury -o jsonpath='{.spec.replicas}')

if [[ "$ready_replicas" == "$desired_replicas" ]] && [[ "$ready_replicas" -gt 0 ]]; then
    echo "✅ PASS: cleaner deployment is running successfully ($ready_replicas/$desired_replicas replicas ready)"
else
    echo "❌ FAIL: cleaner deployment is not running successfully ($ready_replicas/$desired_replicas replicas ready)"
    exit 1
fi

# Get pod name to check containers
pod_name=$(kubectl get pods -n mercury -l app=cleaner --no-headers -o custom-columns=":metadata.name" | head -1)
if [[ -n "$pod_name" ]]; then
    echo "✅ PASS: Found cleaner pod: $pod_name"
else
    echo "❌ FAIL: No cleaner pods found"
    exit 1
fi

# Check if pod has 2 containers (cleaner-con and logger-con) - check both containers and initContainers
regular_containers=$(kubectl get pod "$pod_name" -n mercury -o jsonpath='{.spec.containers[*].name}')
init_containers=$(kubectl get pod "$pod_name" -n mercury -o jsonpath='{.spec.initContainers[*].name}')
sidecar_containers=$(kubectl get pod "$pod_name" -n mercury -o jsonpath='{.spec.initContainers[?(@.restartPolicy=="Always")].name}')

# Count total containers (regular + sidecar initContainers)
regular_count=$(echo "$regular_containers" | wc -w)
sidecar_count=$(echo "$sidecar_containers" | wc -w)
total_count=$((regular_count + sidecar_count))

if [[ "$total_count" == "2" ]]; then
    echo "✅ PASS: Pod has 2 containers (sidecar pattern) - $regular_count regular + $sidecar_count sidecar"
else
    echo "❌ FAIL: Pod has $total_count containers ($regular_count regular + $sidecar_count sidecar), expected 2"
    exit 1
fi

# Check container names (both regular containers and sidecar initContainers)
all_containers="$regular_containers $sidecar_containers"
if [[ "$all_containers" == *"cleaner-con"* ]] && [[ "$all_containers" == *"logger-con"* ]]; then
    echo "✅ PASS: Pod has correct container names (cleaner-con, logger-con)"
else
    echo "❌ FAIL: Pod does not have correct container names, found: $all_containers"
    exit 1
fi

# Check if busybox:1.31.0 image is used for cleaner-con (check both containers and initContainers)
cleaner_image=$(kubectl get pod "$pod_name" -n mercury -o jsonpath='{.spec.containers[?(@.name=="cleaner-con")].image}')
if [[ -z "$cleaner_image" ]]; then
    cleaner_image=$(kubectl get pod "$pod_name" -n mercury -o jsonpath='{.spec.initContainers[?(@.name=="cleaner-con")].image}')
fi
if [[ "$cleaner_image" == "busybox:1.31.0" ]]; then
    echo "✅ PASS: cleaner-con is using correct image (busybox:1.31.0)"
else
    echo "❌ FAIL: cleaner-con is using wrong image ($cleaner_image), expected busybox:1.31.0"
    exit 1
fi

# Check if busybox:1.31.0 image is used for logger-con (check both containers and initContainers)
logger_image=$(kubectl get pod "$pod_name" -n mercury -o jsonpath='{.spec.containers[?(@.name=="logger-con")].image}')
if [[ -z "$logger_image" ]]; then
    logger_image=$(kubectl get pod "$pod_name" -n mercury -o jsonpath='{.spec.initContainers[?(@.name=="logger-con")].image}')
fi
if [[ "$logger_image" == "busybox:1.31.0" ]]; then
    echo "✅ PASS: logger-con is using correct image (busybox:1.31.0)"
else
    echo "❌ FAIL: logger-con is using wrong image ($logger_image), expected busybox:1.31.0"
    exit 1
fi

# Check if pod has shared volume
volumes=$(kubectl get pod "$pod_name" -n mercury -o jsonpath='{.spec.volumes[*].name}')
if [[ -n "$volumes" ]]; then
    echo "✅ PASS: Pod has shared volume(s): $volumes"
else
    echo "❌ FAIL: Pod does not have shared volumes"
    exit 1
fi

# Check if both containers have volume mounts (check both containers and initContainers)
cleaner_mounts=$(kubectl get pod "$pod_name" -n mercury -o jsonpath='{.spec.containers[?(@.name=="cleaner-con")].volumeMounts[*].mountPath}')
if [[ -z "$cleaner_mounts" ]]; then
    cleaner_mounts=$(kubectl get pod "$pod_name" -n mercury -o jsonpath='{.spec.initContainers[?(@.name=="cleaner-con")].volumeMounts[*].mountPath}')
fi
logger_mounts=$(kubectl get pod "$pod_name" -n mercury -o jsonpath='{.spec.containers[?(@.name=="logger-con")].volumeMounts[*].mountPath}')
if [[ -z "$logger_mounts" ]]; then
    logger_mounts=$(kubectl get pod "$pod_name" -n mercury -o jsonpath='{.spec.initContainers[?(@.name=="logger-con")].volumeMounts[*].mountPath}')
fi

if [[ -n "$cleaner_mounts" ]]; then
    echo "✅ PASS: cleaner-con has volume mounts: $cleaner_mounts"
else
    echo "❌ FAIL: cleaner-con does not have volume mounts"
    exit 1
fi

if [[ -n "$logger_mounts" ]]; then
    echo "✅ PASS: logger-con has volume mounts: $logger_mounts"
else
    echo "❌ FAIL: logger-con does not have volume mounts"
    exit 1
fi

echo "🎉 All validations passed for Question 16!"

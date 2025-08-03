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

# Check if pod has 2 containers (cleaner-con and log-reader)
container_count=$(kubectl get pod "$pod_name" -n mercury -o jsonpath='{.spec.containers[*].name}' | wc -w)
if [[ "$container_count" == "2" ]]; then
    echo "✅ PASS: Pod has 2 containers (sidecar pattern)"
else
    echo "❌ FAIL: Pod has $container_count containers, expected 2"
    exit 1
fi

# Check container names
containers=$(kubectl get pod "$pod_name" -n mercury -o jsonpath='{.spec.containers[*].name}')
if [[ "$containers" == *"cleaner-con"* ]] && [[ "$containers" == *"log-reader"* ]]; then
    echo "✅ PASS: Pod has correct container names (cleaner-con, log-reader)"
else
    echo "❌ FAIL: Pod does not have correct container names, found: $containers"
    exit 1
fi

# Check if busybox:1.31.0 image is used for cleaner-con
cleaner_image=$(kubectl get pod "$pod_name" -n mercury -o jsonpath='{.spec.containers[?(@.name=="cleaner-con")].image}')
if [[ "$cleaner_image" == "busybox:1.31.0" ]]; then
    echo "✅ PASS: cleaner-con is using correct image (busybox:1.31.0)"
else
    echo "❌ FAIL: cleaner-con is using wrong image ($cleaner_image), expected busybox:1.31.0"
    exit 1
fi

# Check if nginx:1.21.1-alpine image is used for log-reader
log_reader_image=$(kubectl get pod "$pod_name" -n mercury -o jsonpath='{.spec.containers[?(@.name=="log-reader")].image}')
if [[ "$log_reader_image" == "nginx:1.21.1-alpine" ]]; then
    echo "✅ PASS: log-reader is using correct image (nginx:1.21.1-alpine)"
else
    echo "❌ FAIL: log-reader is using wrong image ($log_reader_image), expected nginx:1.21.1-alpine"
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

# Check if both containers have volume mounts
cleaner_mounts=$(kubectl get pod "$pod_name" -n mercury -o jsonpath='{.spec.containers[?(@.name=="cleaner-con")].volumeMounts[*].mountPath}')
log_reader_mounts=$(kubectl get pod "$pod_name" -n mercury -o jsonpath='{.spec.containers[?(@.name=="log-reader")].volumeMounts[*].mountPath}')

if [[ -n "$cleaner_mounts" ]]; then
    echo "✅ PASS: cleaner-con has volume mounts: $cleaner_mounts"
else
    echo "❌ FAIL: cleaner-con does not have volume mounts"
    exit 1
fi

if [[ -n "$log_reader_mounts" ]]; then
    echo "✅ PASS: log-reader has volume mounts: $log_reader_mounts"
else
    echo "❌ FAIL: log-reader does not have volume mounts"
    exit 1
fi

echo "🎉 All validations passed for Question 16!"

#!/bin/bash

# Validation script for Question 22 - Multi-container Pod (Sidecar, Init Container)
echo "=== Validating Question 22: Multi-container Pod (Sidecar, Init Container) ==="

# Check if cosmos-app pod exists in cosmos namespace
if kubectl get pod cosmos-app -n cosmos &>/dev/null; then
    echo "✅ PASS: cosmos-app pod exists in cosmos namespace"
else
    echo "❌ FAIL: cosmos-app pod not found in cosmos namespace"
    exit 1
fi

# Check pod labels
app_label=$(kubectl get pod cosmos-app -n cosmos -o jsonpath='{.metadata.labels.app}')
tier_label=$(kubectl get pod cosmos-app -n cosmos -o jsonpath='{.metadata.labels.tier}')

if [[ "$app_label" == "cosmos-app" ]]; then
    echo "✅ PASS: Pod has correct app label (cosmos-app)"
else
    echo "❌ FAIL: Pod has wrong app label ($app_label), expected cosmos-app"
    exit 1
fi

if [[ "$tier_label" == "frontend" ]]; then
    echo "✅ PASS: Pod has correct tier label (frontend)"
else
    echo "❌ FAIL: Pod has wrong tier label ($tier_label), expected frontend"
    exit 1
fi

# Check init container
init_container_name=$(kubectl get pod cosmos-app -n cosmos -o jsonpath='{.spec.initContainers[0].name}')
init_container_image=$(kubectl get pod cosmos-app -n cosmos -o jsonpath='{.spec.initContainers[0].image}')

if [[ "$init_container_name" == "cosmos-init" ]]; then
    echo "✅ PASS: Init container has correct name (cosmos-init)"
else
    echo "❌ FAIL: Init container has wrong name ($init_container_name), expected cosmos-init"
    exit 1
fi

if [[ "$init_container_image" == "busybox:1.31.0" ]]; then
    echo "✅ PASS: Init container is using correct image (busybox:1.31.0)"
else
    echo "❌ FAIL: Init container is using wrong image ($init_container_image), expected busybox:1.31.0"
    exit 1
fi

# Check if init container has volume mount
init_volume_mounts=$(kubectl get pod cosmos-app -n cosmos -o jsonpath='{.spec.initContainers[0].volumeMounts[*].name}')
if [[ "$init_volume_mounts" == *"shared-data"* ]]; then
    echo "✅ PASS: Init container has shared-data volume mount"
else
    echo "❌ FAIL: Init container does not have shared-data volume mount"
    exit 1
fi

# Check main containers (should be 2: cosmos-main and cosmos-sidecar)
container_count=$(kubectl get pod cosmos-app -n cosmos -o jsonpath='{.spec.containers[*].name}' | wc -w)
if [[ "$container_count" == "2" ]]; then
    echo "✅ PASS: Pod has 2 main containers"
else
    echo "❌ FAIL: Pod has $container_count main containers, expected 2"
    exit 1
fi

# Check cosmos-main container
main_container_name=$(kubectl get pod cosmos-app -n cosmos -o jsonpath='{.spec.containers[?(@.name=="cosmos-main")].name}')
main_container_image=$(kubectl get pod cosmos-app -n cosmos -o jsonpath='{.spec.containers[?(@.name=="cosmos-main")].image}')

if [[ "$main_container_name" == "cosmos-main" ]]; then
    echo "✅ PASS: Main container has correct name (cosmos-main)"
else
    echo "❌ FAIL: Main container not found or has wrong name"
    exit 1
fi

if [[ "$main_container_image" == "nginx:1.21.1-alpine" ]]; then
    echo "✅ PASS: Main container is using correct image (nginx:1.21.1-alpine)"
else
    echo "❌ FAIL: Main container is using wrong image ($main_container_image), expected nginx:1.21.1-alpine"
    exit 1
fi

# Check cosmos-sidecar container
sidecar_container_name=$(kubectl get pod cosmos-app -n cosmos -o jsonpath='{.spec.containers[?(@.name=="cosmos-sidecar")].name}')
sidecar_container_image=$(kubectl get pod cosmos-app -n cosmos -o jsonpath='{.spec.containers[?(@.name=="cosmos-sidecar")].image}')

if [[ "$sidecar_container_name" == "cosmos-sidecar" ]]; then
    echo "✅ PASS: Sidecar container has correct name (cosmos-sidecar)"
else
    echo "❌ FAIL: Sidecar container not found or has wrong name"
    exit 1
fi

if [[ "$sidecar_container_image" == "busybox:1.31.0" ]]; then
    echo "✅ PASS: Sidecar container is using correct image (busybox:1.31.0)"
else
    echo "❌ FAIL: Sidecar container is using wrong image ($sidecar_container_image), expected busybox:1.31.0"
    exit 1
fi

# Check environment variable in main container
app_name_env=$(kubectl get pod cosmos-app -n cosmos -o jsonpath='{.spec.containers[?(@.name=="cosmos-main")].env[?(@.name=="APP_NAME")].value}')
if [[ "$app_name_env" == "cosmos-application" ]]; then
    echo "✅ PASS: Main container has correct APP_NAME environment variable"
else
    echo "❌ FAIL: Main container does not have correct APP_NAME environment variable"
    exit 1
fi

# Check shared volume
volumes=$(kubectl get pod cosmos-app -n cosmos -o jsonpath='{.spec.volumes[*].name}')
if [[ "$volumes" == *"shared-data"* ]]; then
    echo "✅ PASS: Pod has shared-data volume"
else
    echo "❌ FAIL: Pod does not have shared-data volume"
    exit 1
fi

# Check if main containers have volume mounts to shared volume
main_volume_mounts=$(kubectl get pod cosmos-app -n cosmos -o jsonpath='{.spec.containers[?(@.name=="cosmos-main")].volumeMounts[*].name}')
sidecar_volume_mounts=$(kubectl get pod cosmos-app -n cosmos -o jsonpath='{.spec.containers[?(@.name=="cosmos-sidecar")].volumeMounts[*].name}')

if [[ "$main_volume_mounts" == *"shared-data"* ]]; then
    echo "✅ PASS: Main container has shared-data volume mount"
else
    echo "❌ FAIL: Main container does not have shared-data volume mount"
    exit 1
fi

if [[ "$sidecar_volume_mounts" == *"shared-data"* ]]; then
    echo "✅ PASS: Sidecar container has shared-data volume mount"
else
    echo "❌ FAIL: Sidecar container does not have shared-data volume mount"
    exit 1
fi

# Check if pod is running
pod_status=$(kubectl get pod cosmos-app -n cosmos -o jsonpath='{.status.phase}')
if [[ "$pod_status" == "Running" ]]; then
    echo "✅ PASS: Pod is running"
else
    echo "⚠️  WARNING: Pod is not running (status: $pod_status)"
fi

echo "🎉 All validations passed for Question 22!"

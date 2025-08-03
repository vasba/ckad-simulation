#!/bin/bash

# Validation script for Question 14 - Secret, Secret-Volume, Secret-Env
echo "=== Validating Question 14: Secret, Secret-Volume, Secret-Env ==="

# Check if secret1 exists in moon namespace
if kubectl get secret secret1 -n moon &>/dev/null; then
    echo "✅ PASS: secret1 exists in moon namespace"
else
    echo "❌ FAIL: secret1 not found in moon namespace"
    exit 1
fi

# Check secret1 contents
secret1_user=$(kubectl get secret secret1 -n moon -o jsonpath='{.data.user}' | base64 -d)
secret1_pass=$(kubectl get secret secret1 -n moon -o jsonpath='{.data.pass}' | base64 -d)

if [[ "$secret1_user" == "test" ]]; then
    echo "✅ PASS: secret1 has correct user value (test)"
else
    echo "❌ FAIL: secret1 has wrong user value ($secret1_user), expected test"
    exit 1
fi

if [[ "$secret1_pass" == "pwd" ]]; then
    echo "✅ PASS: secret1 has correct pass value (pwd)"
else
    echo "❌ FAIL: secret1 has wrong pass value ($secret1_pass), expected pwd"
    exit 1
fi

# Check if secret2 exists in moon namespace
if kubectl get secret secret2 -n moon &>/dev/null; then
    echo "✅ PASS: secret2 exists in moon namespace"
else
    echo "❌ FAIL: secret2 not found in moon namespace"
    exit 1
fi

# Check if Pod secret-handler exists in moon namespace
if kubectl get pod secret-handler -n moon &>/dev/null; then
    echo "✅ PASS: Pod secret-handler exists in moon namespace"
else
    echo "❌ FAIL: Pod secret-handler not found in moon namespace"
    exit 1
fi

# Check if Pod is using busybox:1.31.0 image
pod_image=$(kubectl get pod secret-handler -n moon -o jsonpath='{.spec.containers[0].image}')
if [[ "$pod_image" == "busybox:1.31.0" ]]; then
    echo "✅ PASS: Pod is using correct image (busybox:1.31.0)"
else
    echo "❌ FAIL: Pod is using wrong image ($pod_image), expected busybox:1.31.0"
    exit 1
fi

# Check if Pod has environment variables from secret1
env_vars=$(kubectl get pod secret-handler -n moon -o jsonpath='{.spec.containers[0].env[*].name}')
if [[ "$env_vars" == *"SECRET1_USER"* ]] && [[ "$env_vars" == *"SECRET1_PASS"* ]]; then
    echo "✅ PASS: Pod has environment variables from secret1"
else
    echo "❌ FAIL: Pod does not have correct environment variables from secret1"
    exit 1
fi

# Check if Pod has secret2 mounted as volume
volumes=$(kubectl get pod secret-handler -n moon -o jsonpath='{.spec.volumes[*].secret.secretName}')
if [[ "$volumes" == *"secret2"* ]]; then
    echo "✅ PASS: Pod has secret2 mounted as volume"
else
    echo "❌ FAIL: Pod does not have secret2 mounted as volume"
    exit 1
fi

# Check if Pod has volume mount
volume_mounts=$(kubectl get pod secret-handler -n moon -o jsonpath='{.spec.containers[0].volumeMounts[*].name}')
if [[ -n "$volume_mounts" ]]; then
    echo "✅ PASS: Pod has volume mounts configured"
else
    echo "❌ FAIL: Pod does not have volume mounts configured"
    exit 1
fi

# Check if Pod is running
pod_status=$(kubectl get pod secret-handler -n moon -o jsonpath='{.status.phase}')
if [[ "$pod_status" == "Running" ]]; then
    echo "✅ PASS: Pod is running"
else
    echo "⚠️  WARNING: Pod is not running (status: $pod_status)"
fi

echo "🎉 All validations passed for Question 14!"

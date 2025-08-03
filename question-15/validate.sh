#!/bin/bash

# Validation script for Question 15 - ConfigMap, Configmap-Volume
echo "=== Validating Question 15: ConfigMap, Configmap-Volume ==="

# Check if ConfigMap configmap-web-moon-html exists in moon namespace
if kubectl get configmap configmap-web-moon-html -n moon &>/dev/null; then
    echo "✅ PASS: ConfigMap configmap-web-moon-html exists in moon namespace"
else
    echo "❌ FAIL: ConfigMap configmap-web-moon-html not found in moon namespace"
    exit 1
fi

# Check if ConfigMap contains index.html data
configmap_data=$(kubectl get configmap configmap-web-moon-html -n moon -o jsonpath='{.data}')
if [[ "$configmap_data" == *"index.html"* ]]; then
    echo "✅ PASS: ConfigMap contains index.html data"
else
    echo "❌ FAIL: ConfigMap does not contain index.html data"
    exit 1
fi

# Check if web-moon deployment exists
if kubectl get deployment web-moon -n moon &>/dev/null; then
    echo "✅ PASS: web-moon deployment exists in moon namespace"
else
    echo "❌ FAIL: web-moon deployment not found in moon namespace"
    exit 1
fi

# Check if deployment is running successfully
ready_replicas=$(kubectl get deployment web-moon -n moon -o jsonpath='{.status.readyReplicas}')
desired_replicas=$(kubectl get deployment web-moon -n moon -o jsonpath='{.spec.replicas}')

if [[ "$ready_replicas" == "$desired_replicas" ]] && [[ "$ready_replicas" -gt 0 ]]; then
    echo "✅ PASS: web-moon deployment is running successfully ($ready_replicas/$desired_replicas replicas ready)"
else
    echo "❌ FAIL: web-moon deployment is not running successfully ($ready_replicas/$desired_replicas replicas ready)"
    exit 1
fi

# Check if pods have the ConfigMap mounted as a volume
pod_name=$(kubectl get pods -n moon -l app=web-moon --no-headers -o custom-columns=":metadata.name" | head -1)
if [[ -n "$pod_name" ]]; then
    volumes=$(kubectl get pod "$pod_name" -n moon -o jsonpath='{.spec.volumes[*].configMap.name}')
    if [[ "$volumes" == *"configmap-web-moon-html"* ]]; then
        echo "✅ PASS: Pod has ConfigMap mounted as volume"
    else
        echo "❌ FAIL: Pod does not have ConfigMap mounted as volume"
        exit 1
    fi
    
    # Check if volume is mounted to correct path
    volume_mounts=$(kubectl get pod "$pod_name" -n moon -o jsonpath='{.spec.containers[0].volumeMounts[*].mountPath}')
    if [[ "$volume_mounts" == *"/usr/share/nginx/html"* ]]; then
        echo "✅ PASS: ConfigMap volume is mounted to correct path (/usr/share/nginx/html)"
    else
        echo "⚠️  WARNING: ConfigMap volume mount path may not be correct"
    fi
else
    echo "❌ FAIL: No web-moon pods found"
    exit 1
fi

# Check if original web-moon.html file exists
if [[ -f "$HOME/ckad-simulation/15/web-moon.html" ]]; then
    echo "✅ PASS: Original web-moon.html file exists"
else
    echo "⚠️  WARNING: Original web-moon.html file not found at expected location"
fi

# Try to test if the nginx server is serving the custom content
# This is optional since it requires network access
pod_ip=$(kubectl get pod "$pod_name" -n moon -o jsonpath='{.status.podIP}' 2>/dev/null)
if [[ -n "$pod_ip" ]]; then
    echo "✅ PASS: Pod has IP address assigned ($pod_ip)"
    echo "ℹ️  INFO: You can test the nginx server with: kubectl run tmp --restart=Never --rm -i --image=nginx:alpine -- curl $pod_ip"
else
    echo "⚠️  WARNING: Could not get pod IP address"
fi

echo "🎉 All validations passed for Question 15!"

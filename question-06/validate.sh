#!/bin/bash

# Validation script for Question 6 - ReadinessProbe
echo "=== Validating Question 6: ReadinessProbe ==="

# Check if pod6 exists
if kubectl get pod pod6 &>/dev/null; then
    echo "✅ PASS: pod6 exists"
else
    echo "❌ FAIL: pod6 not found"
    exit 1
fi

# Check if pod6 is using busybox:1.31.0 image
pod_image=$(kubectl get pod pod6 -o jsonpath='{.spec.containers[0].image}')
if [[ "$pod_image" == "busybox:1.31.0" ]]; then
    echo "✅ PASS: pod6 is using correct image (busybox:1.31.0)"
else
    echo "❌ FAIL: pod6 is using wrong image ($pod_image), expected busybox:1.31.0"
    exit 1
fi

# Check if readiness probe exists
readiness_probe=$(kubectl get pod pod6 -o jsonpath='{.spec.containers[0].readinessProbe}')
if [[ -n "$readiness_probe" ]]; then
    echo "✅ PASS: pod6 has readiness probe configured"
else
    echo "❌ FAIL: pod6 does not have readiness probe configured"
    exit 1
fi

# Check if readiness probe uses exec command
probe_command=$(kubectl get pod pod6 -o jsonpath='{.spec.containers[0].readinessProbe.exec.command[*]}')
if [[ "$probe_command" == *"cat /tmp/ready"* ]] || [[ "$probe_command" == *"sh -c cat /tmp/ready"* ]]; then
    echo "✅ PASS: readiness probe uses correct command (cat /tmp/ready)"
else
    echo "❌ FAIL: readiness probe command is incorrect, found: $probe_command"
    exit 1
fi

# Check initialDelaySeconds
initial_delay=$(kubectl get pod pod6 -o jsonpath='{.spec.containers[0].readinessProbe.initialDelaySeconds}')
if [[ "$initial_delay" == "5" ]]; then
    echo "✅ PASS: readiness probe has correct initialDelaySeconds (5)"
else
    echo "❌ FAIL: readiness probe initialDelaySeconds is wrong ($initial_delay), expected 5"
    exit 1
fi

# Check periodSeconds
period_seconds=$(kubectl get pod pod6 -o jsonpath='{.spec.containers[0].readinessProbe.periodSeconds}')
if [[ "$period_seconds" == "10" ]]; then
    echo "✅ PASS: readiness probe has correct periodSeconds (10)"
else
    echo "❌ FAIL: readiness probe periodSeconds is wrong ($period_seconds), expected 10"
    exit 1
fi

# Check if pod is ready (the readiness probe should pass)
pod_ready=$(kubectl get pod pod6 -o jsonpath='{.status.conditions[?(@.type=="Ready")].status}')
if [[ "$pod_ready" == "True" ]]; then
    echo "✅ PASS: pod6 is ready (readiness probe passing)"
else
    echo "⚠️  WARNING: pod6 is not ready yet, readiness probe may still be running"
fi

echo "🎉 All validations passed for Question 6!"

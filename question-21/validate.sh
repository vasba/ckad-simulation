#!/bin/bash

# Validation script for Question 21 - SecurityContext, PodSecurityContext
echo "=== Validating Question 21: SecurityContext, PodSecurityContext ==="

# Check if galaxy-secure pod exists in galaxy namespace
if kubectl get pod galaxy-secure -n galaxy &>/dev/null; then
    echo "✅ PASS: galaxy-secure pod exists in galaxy namespace"
else
    echo "❌ FAIL: galaxy-secure pod not found in galaxy namespace"
    exit 1
fi

# Check if pod is using correct image
image=$(kubectl get pod galaxy-secure -n galaxy -o jsonpath='{.spec.containers[0].image}')
if [[ "$image" == "nginx:1.21.1-alpine" ]]; then
    echo "✅ PASS: Pod is using correct image (nginx:1.21.1-alpine)"
else
    echo "❌ FAIL: Pod is using wrong image ($image), expected nginx:1.21.1-alpine"
    exit 1
fi

# Check pod security context
run_as_user=$(kubectl get pod galaxy-secure -n galaxy -o jsonpath='{.spec.securityContext.runAsUser}')
run_as_group=$(kubectl get pod galaxy-secure -n galaxy -o jsonpath='{.spec.securityContext.runAsGroup}')
fs_group=$(kubectl get pod galaxy-secure -n galaxy -o jsonpath='{.spec.securityContext.fsGroup}')

if [[ "$run_as_user" == "1000" ]]; then
    echo "✅ PASS: Pod securityContext runAsUser is correct (1000)"
else
    echo "❌ FAIL: Pod securityContext runAsUser is wrong ($run_as_user), expected 1000"
    exit 1
fi

if [[ "$run_as_group" == "3000" ]]; then
    echo "✅ PASS: Pod securityContext runAsGroup is correct (3000)"
else
    echo "❌ FAIL: Pod securityContext runAsGroup is wrong ($run_as_group), expected 3000"
    exit 1
fi

if [[ "$fs_group" == "2000" ]]; then
    echo "✅ PASS: Pod securityContext fsGroup is correct (2000)"
else
    echo "❌ FAIL: Pod securityContext fsGroup is wrong ($fs_group), expected 2000"
    exit 1
fi

# Check container security context
run_as_non_root=$(kubectl get pod galaxy-secure -n galaxy -o jsonpath='{.spec.containers[0].securityContext.runAsNonRoot}')
read_only_root=$(kubectl get pod galaxy-secure -n galaxy -o jsonpath='{.spec.containers[0].securityContext.readOnlyRootFilesystem}')
allow_privilege_escalation=$(kubectl get pod galaxy-secure -n galaxy -o jsonpath='{.spec.containers[0].securityContext.allowPrivilegeEscalation}')

if [[ "$run_as_non_root" == "true" ]]; then
    echo "✅ PASS: Container securityContext runAsNonRoot is correct (true)"
else
    echo "❌ FAIL: Container securityContext runAsNonRoot is wrong ($run_as_non_root), expected true"
    exit 1
fi

if [[ "$read_only_root" == "true" ]]; then
    echo "✅ PASS: Container securityContext readOnlyRootFilesystem is correct (true)"
else
    echo "❌ FAIL: Container securityContext readOnlyRootFilesystem is wrong ($read_only_root), expected true"
    exit 1
fi

if [[ "$allow_privilege_escalation" == "false" ]]; then
    echo "✅ PASS: Container securityContext allowPrivilegeEscalation is correct (false)"
else
    echo "❌ FAIL: Container securityContext allowPrivilegeEscalation is wrong ($allow_privilege_escalation), expected false"
    exit 1
fi

# Check capabilities
capabilities_drop=$(kubectl get pod galaxy-secure -n galaxy -o jsonpath='{.spec.containers[0].securityContext.capabilities.drop[*]}')
capabilities_add=$(kubectl get pod galaxy-secure -n galaxy -o jsonpath='{.spec.containers[0].securityContext.capabilities.add[*]}')

if [[ "$capabilities_drop" == *"ALL"* ]]; then
    echo "✅ PASS: Container capabilities drop ALL"
else
    echo "❌ FAIL: Container capabilities do not drop ALL, found: $capabilities_drop"
    exit 1
fi

if [[ "$capabilities_add" == *"NET_BIND_SERVICE"* ]]; then
    echo "✅ PASS: Container capabilities add NET_BIND_SERVICE"
else
    echo "❌ FAIL: Container capabilities do not add NET_BIND_SERVICE, found: $capabilities_add"
    exit 1
fi

# Check volume mounts
volume_mounts=$(kubectl get pod galaxy-secure -n galaxy -o jsonpath='{.spec.containers[0].volumeMounts[*].name}')
if [[ "$volume_mounts" == *"tmp"* ]] && [[ "$volume_mounts" == *"cache"* ]]; then
    echo "✅ PASS: Container has required volume mounts (tmp, cache)"
else
    echo "❌ FAIL: Container does not have required volume mounts, found: $volume_mounts"
    exit 1
fi

# Check volumes
volumes=$(kubectl get pod galaxy-secure -n galaxy -o jsonpath='{.spec.volumes[*].name}')
if [[ "$volumes" == *"tmp"* ]] && [[ "$volumes" == *"cache"* ]]; then
    echo "✅ PASS: Pod has required volumes (tmp, cache)"
else
    echo "❌ FAIL: Pod does not have required volumes, found: $volumes"
    exit 1
fi

# Check if pod is running
pod_status=$(kubectl get pod galaxy-secure -n galaxy -o jsonpath='{.status.phase}')
if [[ "$pod_status" == "Running" ]]; then
    echo "✅ PASS: Pod is running"
else
    echo "⚠️  WARNING: Pod is not running (status: $pod_status)"
fi

echo "🎉 All validations passed for Question 21!"

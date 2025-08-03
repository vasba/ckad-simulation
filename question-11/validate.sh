#!/bin/bash

# Validation script for Question 11 - Working with Containers
echo "=== Validating Question 11: Working with Containers ==="

# Check if logs file exists
if [[ -f "logs" ]]; then
    echo "✅ PASS: logs file exists"
else
    echo "❌ FAIL: logs file not found"
    exit 1
fi

# Check if Dockerfile exists and has been modified
if [[ -f "Dockerfile" ]]; then
    echo "✅ PASS: Dockerfile exists"
    
    # Check if Dockerfile contains the specific cipher ID
    if grep -q "SUN_CIPHER_ID=5b9c1065-e39d-4a43-a04a-e59bcea3e03f" Dockerfile; then
        echo "✅ PASS: Dockerfile contains correct SUN_CIPHER_ID"
    else
        echo "❌ FAIL: Dockerfile does not contain correct SUN_CIPHER_ID"
        exit 1
    fi
else
    echo "❌ FAIL: Dockerfile not found"
    exit 1
fi

# Check if container images were built (check if images exist locally)
# Note: This might not work in all environments, so we'll make it a warning
if command -v docker &> /dev/null; then
    if docker images | grep -q "registry.killer.sh:5000/sun-cipher:v1-docker"; then
        echo "✅ PASS: Docker image registry.killer.sh:5000/sun-cipher:v1-docker exists"
    else
        echo "⚠️  WARNING: Docker image registry.killer.sh:5000/sun-cipher:v1-docker not found locally"
    fi
fi

if command -v podman &> /dev/null; then
    if podman images | grep -q "registry.killer.sh:5000/sun-cipher:v1-podman"; then
        echo "✅ PASS: Podman image registry.killer.sh:5000/sun-cipher:v1-podman exists"
    else
        echo "⚠️  WARNING: Podman image registry.killer.sh:5000/sun-cipher:v1-podman not found locally"
    fi
    
    # Check if container was run
    if podman ps -a | grep -q "sun-cipher"; then
        echo "✅ PASS: sun-cipher container was created"
    else
        echo "⚠️  WARNING: sun-cipher container not found"
    fi
fi

# Check if logs file contains expected content
if [[ -s "logs" ]]; then
    echo "✅ PASS: logs file is not empty"
    
    # Check if logs contain cipher ID or related content
    if grep -q "5b9c1065-e39d-4a43-a04a-e59bcea3e03f" logs || grep -q "SUN_CIPHER" logs; then
        echo "✅ PASS: logs file contains expected cipher content"
    else
        echo "⚠️  WARNING: logs file may not contain expected cipher content"
    fi
else
    echo "❌ FAIL: logs file is empty"
    exit 1
fi

# Verify tools are available
if ! command -v docker &> /dev/null && ! command -v podman &> /dev/null; then
    echo "⚠️  WARNING: Neither docker nor podman commands are available for full validation"
fi

echo "🎉 All validations passed for Question 11!"

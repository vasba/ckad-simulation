#!/bin/bash

# Validation script for Question 1 - Namespaces
echo "=== Validating Question 1: Namespaces ==="

# Check if namespaces file exists
if [[ ! -f "namespaces" ]]; then
    echo "❌ FAIL: 'namespaces' file not found"
    exit 1
fi

echo "✅ PASS: 'namespaces' file exists"

# Check if file contains expected namespaces
required_namespaces=("default" "earth" "jupiter" "kube-node-lease" "kube-public" "kube-system" "mars" "shell-intern")
missing_namespaces=()

for ns in "${required_namespaces[@]}"; do
    if ! grep -q "^$ns" namespaces; then
        missing_namespaces+=("$ns")
    fi
done

if [[ ${#missing_namespaces[@]} -eq 0 ]]; then
    echo "✅ PASS: All required namespaces found in file"
else
    echo "❌ FAIL: Missing namespaces: ${missing_namespaces[*]}"
    exit 1
fi

# Check if file has proper format (NAME, STATUS, AGE columns)
if grep -q "NAME.*STATUS.*AGE" namespaces; then
    echo "✅ PASS: File has proper header format"
else
    echo "❌ FAIL: File missing proper header (NAME, STATUS, AGE)"
    exit 1
fi

echo "🎉 All validations passed for Question 1!"

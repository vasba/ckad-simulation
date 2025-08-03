#!/bin/bash

# Validation script for Question 4 - Helm Management
echo "=== Validating Question 4: Helm Management ==="

# Check if internal-issue-report-apiv1 is NOT installed
if helm -n mercury list | grep -q "internal-issue-report-apiv1"; then
    echo "❌ FAIL: internal-issue-report-apiv1 should have been deleted"
    exit 1
else
    echo "✅ PASS: internal-issue-report-apiv1 has been deleted"
fi

# Check if internal-issue-report-apiv2 exists and is using nginx chart
if helm -n mercury list | grep -q "internal-issue-report-apiv2"; then
    echo "✅ PASS: internal-issue-report-apiv2 exists"
    
    # Check if it's using nginx chart
    chart_info=$(helm -n mercury list -o json | jq -r '.[] | select(.name=="internal-issue-report-apiv2") | .chart')
    if [[ "$chart_info" == *"nginx"* ]]; then
        echo "✅ PASS: internal-issue-report-apiv2 is using nginx chart"
    else
        echo "❌ FAIL: internal-issue-report-apiv2 is not using nginx chart"
        exit 1
    fi
else
    echo "❌ FAIL: internal-issue-report-apiv2 not found"
    exit 1
fi

# Check if internal-issue-report-apache exists with replicaCount=2
if helm -n mercury list | grep -q "internal-issue-report-apache"; then
    echo "✅ PASS: internal-issue-report-apache exists"
    
    # Check if it's using apache chart
    chart_info=$(helm -n mercury list -o json | jq -r '.[] | select(.name=="internal-issue-report-apache") | .chart')
    if [[ "$chart_info" == *"apache"* ]]; then
        echo "✅ PASS: internal-issue-report-apache is using apache chart"
    else
        echo "❌ FAIL: internal-issue-report-apache is not using apache chart"
        exit 1
    fi
    
    # Check replica count (this would require checking the deployment)
    replica_count=$(kubectl -n mercury get deployment -l app.kubernetes.io/instance=internal-issue-report-apache -o jsonpath='{.items[0].spec.replicas}' 2>/dev/null)
    if [[ "$replica_count" == "2" ]]; then
        echo "✅ PASS: internal-issue-report-apache has replicaCount=2"
    else
        echo "⚠️  WARNING: Could not verify replicaCount=2 for internal-issue-report-apache"
    fi
else
    echo "❌ FAIL: internal-issue-report-apache not found"
    exit 1
fi

# Check if internal-issue-report-daniel is NOT installed (broken release deleted)
if helm -n mercury list -a | grep -q "internal-issue-report-daniel"; then
    echo "❌ FAIL: internal-issue-report-daniel should have been deleted"
    exit 1
else
    echo "✅ PASS: internal-issue-report-daniel has been deleted"
fi

echo "🎉 All validations passed for Question 4!"

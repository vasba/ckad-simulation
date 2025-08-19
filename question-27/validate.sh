#!/bin/bash

# Validation script for Question 27 - Labels, Annotations
echo "=== Validating Question 27: Labels, Annotations ==="

# Check if the sun namespace exists
if ! kubectl get namespace sun &>/dev/null; then
    echo "❌ FAIL: Namespace 'sun' not found"
    exit 1
fi

echo "✅ PASS: Namespace 'sun' exists"

# Check if pods exist
POD_COUNT=$(kubectl get pods -n sun --no-headers | wc -l)
if [[ "$POD_COUNT" -eq 0 ]]; then
    echo "❌ FAIL: No pods found in namespace 'sun'"
    exit 1
fi

echo "✅ PASS: Found $POD_COUNT pods in namespace 'sun'"

# Get all pods that should have the protected=true label (type=worker or type=runner)
WORKER_PODS=$(kubectl get pods -n sun -l type=worker --no-headers -o custom-columns=":metadata.name" | tr '\n' ' ')
RUNNER_PODS=$(kubectl get pods -n sun -l type=runner --no-headers -o custom-columns=":metadata.name" | tr '\n' ' ')

echo "📋 Pods with type=worker: $WORKER_PODS"
echo "📋 Pods with type=runner: $RUNNER_PODS"

# Check if all worker pods have protected=true label
if [[ -n "$WORKER_PODS" ]]; then
    for pod in $WORKER_PODS; do
        PROTECTED_LABEL=$(kubectl get pod $pod -n sun -o jsonpath='{.metadata.labels.protected}')
        if [[ "$PROTECTED_LABEL" != "true" ]]; then
            echo "❌ FAIL: Pod '$pod' with type=worker missing 'protected=true' label"
            exit 1
        fi
    done
    echo "✅ PASS: All worker pods have 'protected=true' label"
fi

# Check if all runner pods have protected=true label  
if [[ -n "$RUNNER_PODS" ]]; then
    for pod in $RUNNER_PODS; do
        PROTECTED_LABEL=$(kubectl get pod $pod -n sun -o jsonpath='{.metadata.labels.protected}')
        if [[ "$PROTECTED_LABEL" != "true" ]]; then
            echo "❌ FAIL: Pod '$pod' with type=runner missing 'protected=true' label"
            exit 1
        fi
    done
    echo "✅ PASS: All runner pods have 'protected=true' label"
fi

# Check that pods without type=worker or type=runner do NOT have protected=true label
OTHER_PODS=$(kubectl get pods -n sun -l 'type notin (worker,runner)' --no-headers -o custom-columns=":metadata.name" | tr '\n' ' ')
if [[ -n "$OTHER_PODS" ]]; then
    for pod in $OTHER_PODS; do
        PROTECTED_LABEL=$(kubectl get pod $pod -n sun -o jsonpath='{.metadata.labels.protected}')
        if [[ "$PROTECTED_LABEL" == "true" ]]; then
            echo "❌ FAIL: Pod '$pod' should NOT have 'protected=true' label (type is not worker or runner)"
            exit 1
        fi
    done
    echo "✅ PASS: Pods without type=worker/runner correctly do NOT have 'protected=true' label"
fi

# Check if all pods with protected=true have the correct annotation
PROTECTED_PODS=$(kubectl get pods -n sun -l protected=true --no-headers -o custom-columns=":metadata.name" | tr '\n' ' ')
if [[ -z "$PROTECTED_PODS" ]]; then
    echo "❌ FAIL: No pods found with 'protected=true' label"
    exit 1
fi

echo "📋 Pods with protected=true: $PROTECTED_PODS"

for pod in $PROTECTED_PODS; do
    ANNOTATION=$(kubectl get pod $pod -n sun -o jsonpath='{.metadata.annotations.protected}')
    if [[ "$ANNOTATION" != "do not delete this pod" ]]; then
        echo "❌ FAIL: Pod '$pod' missing annotation 'protected=do not delete this pod'"
        echo "    Found annotation: '$ANNOTATION'"
        exit 1
    fi
done

echo "✅ PASS: All protected pods have correct annotation"

# Count expected vs actual protected pods
EXPECTED_PROTECTED_COUNT=$(kubectl get pods -n sun -l 'type in (worker,runner)' --no-headers | wc -l)
ACTUAL_PROTECTED_COUNT=$(kubectl get pods -n sun -l protected=true --no-headers | wc -l)

if [[ "$EXPECTED_PROTECTED_COUNT" != "$ACTUAL_PROTECTED_COUNT" ]]; then
    echo "❌ FAIL: Expected $EXPECTED_PROTECTED_COUNT protected pods, found $ACTUAL_PROTECTED_COUNT"
    exit 1
fi

echo "✅ PASS: Correct number of protected pods ($ACTUAL_PROTECTED_COUNT)"

# Display summary
echo ""
echo "📊 Summary:"
echo "  - Total pods: $POD_COUNT"
echo "  - Pods with type=worker: $(echo $WORKER_PODS | wc -w)"
echo "  - Pods with type=runner: $(echo $RUNNER_PODS | wc -w)" 
echo "  - Pods with protected=true: $ACTUAL_PROTECTED_COUNT"
echo "  - Pods with other labels: $(echo $OTHER_PODS | wc -w)"

echo ""
echo "🎉 All validation checks passed!"
echo "Labels and annotations have been correctly applied!"

#!/bin/bash

# Validation script for Question 3 - Job
echo "=== Validating Question 3: Job ==="

# Check if job exists in neptune namespace
if kubectl get job neb-new-job -n neptune &>/dev/null; then
    echo "✅ PASS: neb-new-job exists in neptune namespace"
else
    echo "❌ FAIL: neb-new-job not found in neptune namespace"
    exit 1
fi

# Check if job has correct image
job_image=$(kubectl get job neb-new-job -n neptune -o jsonpath='{.spec.template.spec.containers[0].image}')
if [[ "$job_image" == "busybox:1.31.0" ]]; then
    echo "✅ PASS: Job is using correct image (busybox:1.31.0)"
else
    echo "❌ FAIL: Job is using wrong image ($job_image), expected busybox:1.31.0"
    exit 1
fi

# Check completions
completions=$(kubectl get job neb-new-job -n neptune -o jsonpath='{.spec.completions}')
if [[ "$completions" == "3" ]]; then
    echo "✅ PASS: Job has correct completions (3)"
else
    echo "❌ FAIL: Job has wrong completions ($completions), expected 3"
    exit 1
fi

# Check parallelism
parallelism=$(kubectl get job neb-new-job -n neptune -o jsonpath='{.spec.parallelism}')
if [[ "$parallelism" == "2" ]]; then
    echo "✅ PASS: Job has correct parallelism (2)"
else
    echo "❌ FAIL: Job has wrong parallelism ($parallelism), expected 2"
    exit 1
fi

# Check label
label_value=$(kubectl get job neb-new-job -n neptune -o jsonpath='{.metadata.labels.id}')
if [[ "$label_value" == "awesome-job" ]]; then
    echo "✅ PASS: Job has correct label (id: awesome-job)"
else
    echo "❌ FAIL: Job has wrong label ($label_value), expected id: awesome-job"
    exit 1
fi

# Check container name
container_name=$(kubectl get job neb-new-job -n neptune -o jsonpath='{.spec.template.spec.containers[0].name}')
if [[ "$container_name" == "neb-new-job-container" ]]; then
    echo "✅ PASS: Container name is correct (neb-new-job-container)"
else
    echo "❌ FAIL: Container name is wrong ($container_name), expected neb-new-job-container"
    exit 1
fi

echo "🎉 All validations passed for Question 3!"

#!/bin/bash

# Validation script for Question 10 - Service, Logs
echo "=== Validating Question 10: Service, Logs ==="

# Check if pod project-plt-6cc-api exists in pluto namespace
if kubectl get pod project-plt-6cc-api -n pluto &>/dev/null; then
    echo "✅ PASS: project-plt-6cc-api pod exists in pluto namespace"
else
    echo "❌ FAIL: project-plt-6cc-api pod not found in pluto namespace"
    exit 1
fi

# Check if pod is using correct image
pod_image=$(kubectl get pod project-plt-6cc-api -n pluto -o jsonpath='{.spec.containers[0].image}')
if [[ "$pod_image" == "nginx:1.17.3-alpine" ]]; then
    echo "✅ PASS: Pod is using correct image (nginx:1.17.3-alpine)"
else
    echo "❌ FAIL: Pod is using wrong image ($pod_image), expected nginx:1.17.3-alpine"
    exit 1
fi

# Check if pod has correct label
pod_label=$(kubectl get pod project-plt-6cc-api -n pluto -o jsonpath='{.metadata.labels.project}')
if [[ "$pod_label" == "plt-6cc-api" ]]; then
    echo "✅ PASS: Pod has correct label (project=plt-6cc-api)"
else
    echo "❌ FAIL: Pod has wrong label ($pod_label), expected project=plt-6cc-api"
    exit 1
fi

# Check if service project-plt-6cc-svc exists
if kubectl get svc project-plt-6cc-svc -n pluto &>/dev/null; then
    echo "✅ PASS: project-plt-6cc-svc service exists in pluto namespace"
else
    echo "❌ FAIL: project-plt-6cc-svc service not found in pluto namespace"
    exit 1
fi

# Check if service is configured correctly
service_port=$(kubectl get svc project-plt-6cc-svc -n pluto -o jsonpath='{.spec.ports[0].port}')
target_port=$(kubectl get svc project-plt-6cc-svc -n pluto -o jsonpath='{.spec.ports[0].targetPort}')

if [[ "$service_port" == "3333" ]]; then
    echo "✅ PASS: Service port is correct (3333)"
else
    echo "❌ FAIL: Service port is wrong ($service_port), expected 3333"
    exit 1
fi

if [[ "$target_port" == "80" ]]; then
    echo "✅ PASS: Service target port is correct (80)"
else
    echo "❌ FAIL: Service target port is wrong ($target_port), expected 80"
    exit 1
fi

# Check if service_test.html file exists
if [[ -f "service_test.html" ]]; then
    echo "✅ PASS: service_test.html file exists"
    
    # Check if file contains HTML content (nginx default page)
    if grep -q "nginx" service_test.html || grep -q "Welcome" service_test.html || grep -q "<html" service_test.html; then
        echo "✅ PASS: service_test.html contains expected HTML content"
    else
        echo "❌ FAIL: service_test.html does not contain expected HTML content"
        exit 1
    fi
else
    echo "❌ FAIL: service_test.html file not found"
    exit 1
fi

# Check if service_test.log file exists
if [[ -f "service_test.log" ]]; then
    echo "✅ PASS: service_test.log file exists"
    
    # Check if log file contains some content
    if [[ -s "service_test.log" ]]; then
        echo "✅ PASS: service_test.log file is not empty"
    else
        echo "⚠️  WARNING: service_test.log file is empty"
    fi
else
    echo "❌ FAIL: service_test.log file not found"
    exit 1
fi

echo "🎉 All validations passed for Question 10!"

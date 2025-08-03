#!/bin/bash

# Validation script for Question 18 - Ingress
echo "=== Validating Question 18: Ingress ==="

# Check if venus-app pod exists in venus namespace
if kubectl get pod venus-app -n venus &>/dev/null; then
    echo "✅ PASS: venus-app pod exists in venus namespace"
else
    echo "❌ FAIL: venus-app pod not found in venus namespace"
    exit 1
fi

# Check if venus-api pod exists in venus namespace
if kubectl get pod venus-api -n venus &>/dev/null; then
    echo "✅ PASS: venus-api pod exists in venus namespace"
else
    echo "❌ FAIL: venus-api pod not found in venus namespace"
    exit 1
fi

# Check venus-app pod image
app_image=$(kubectl get pod venus-app -n venus -o jsonpath='{.spec.containers[0].image}')
if [[ "$app_image" == "nginx:1.21.1-alpine" ]]; then
    echo "✅ PASS: venus-app pod is using correct image (nginx:1.21.1-alpine)"
else
    echo "❌ FAIL: venus-app pod is using wrong image ($app_image), expected nginx:1.21.1-alpine"
    exit 1
fi

# Check venus-api pod image
api_image=$(kubectl get pod venus-api -n venus -o jsonpath='{.spec.containers[0].image}')
if [[ "$api_image" == "httpd:2.4.41-alpine" ]]; then
    echo "✅ PASS: venus-api pod is using correct image (httpd:2.4.41-alpine)"
else
    echo "❌ FAIL: venus-api pod is using wrong image ($api_image), expected httpd:2.4.41-alpine"
    exit 1
fi

# Check if venus-app-svc service exists
if kubectl get svc venus-app-svc -n venus &>/dev/null; then
    echo "✅ PASS: venus-app-svc service exists in venus namespace"
else
    echo "❌ FAIL: venus-app-svc service not found in venus namespace"
    exit 1
fi

# Check if venus-api-svc service exists
if kubectl get svc venus-api-svc -n venus &>/dev/null; then
    echo "✅ PASS: venus-api-svc service exists in venus namespace"
else
    echo "❌ FAIL: venus-api-svc service not found in venus namespace"
    exit 1
fi

# Check venus-app-svc port configuration
app_svc_port=$(kubectl get svc venus-app-svc -n venus -o jsonpath='{.spec.ports[0].port}')
if [[ "$app_svc_port" == "80" ]]; then
    echo "✅ PASS: venus-app-svc has correct port (80)"
else
    echo "❌ FAIL: venus-app-svc has wrong port ($app_svc_port), expected 80"
    exit 1
fi

# Check venus-api-svc port configuration
api_svc_port=$(kubectl get svc venus-api-svc -n venus -o jsonpath='{.spec.ports[0].port}')
api_svc_target_port=$(kubectl get svc venus-api-svc -n venus -o jsonpath='{.spec.ports[0].targetPort}')

if [[ "$api_svc_port" == "8080" ]]; then
    echo "✅ PASS: venus-api-svc has correct port (8080)"
else
    echo "❌ FAIL: venus-api-svc has wrong port ($api_svc_port), expected 8080"
    exit 1
fi

if [[ "$api_svc_target_port" == "80" ]]; then
    echo "✅ PASS: venus-api-svc has correct target port (80)"
else
    echo "❌ FAIL: venus-api-svc has wrong target port ($api_svc_target_port), expected 80"
    exit 1
fi

# Check if venus-ingress exists
if kubectl get ingress venus-ingress -n venus &>/dev/null; then
    echo "✅ PASS: venus-ingress exists in venus namespace"
else
    echo "❌ FAIL: venus-ingress not found in venus namespace"
    exit 1
fi

# Check ingress class
ingress_class=$(kubectl get ingress venus-ingress -n venus -o jsonpath='{.spec.ingressClassName}')
if [[ "$ingress_class" == "nginx" ]]; then
    echo "✅ PASS: venus-ingress uses correct ingress class (nginx)"
else
    echo "❌ FAIL: venus-ingress uses wrong ingress class ($ingress_class), expected nginx"
    exit 1
fi

# Check ingress host
ingress_host=$(kubectl get ingress venus-ingress -n venus -o jsonpath='{.spec.rules[0].host}')
if [[ "$ingress_host" == "venus.example.com" ]]; then
    echo "✅ PASS: venus-ingress has correct host (venus.example.com)"
else
    echo "❌ FAIL: venus-ingress has wrong host ($ingress_host), expected venus.example.com"
    exit 1
fi

# Check ingress paths
ingress_paths=$(kubectl get ingress venus-ingress -n venus -o jsonpath='{.spec.rules[0].http.paths[*].path}')
if [[ "$ingress_paths" == *"/app"* ]] && [[ "$ingress_paths" == *"/api"* ]]; then
    echo "✅ PASS: venus-ingress has correct paths (/app and /api)"
else
    echo "❌ FAIL: venus-ingress does not have correct paths, found: $ingress_paths"
    exit 1
fi

# Check backend services
backends=$(kubectl get ingress venus-ingress -n venus -o jsonpath='{.spec.rules[0].http.paths[*].backend.service.name}')
if [[ "$backends" == *"venus-app-svc"* ]] && [[ "$backends" == *"venus-api-svc"* ]]; then
    echo "✅ PASS: venus-ingress points to correct backend services"
else
    echo "❌ FAIL: venus-ingress does not point to correct backend services, found: $backends"
    exit 1
fi

echo "🎉 All validations passed for Question 18!"

#!/bin/bash

# Question 4 - Helm Management Cleanup
# Removes all resources created for this exercise

echo "Cleaning up Question 4 - Helm Management exercise..."

# Delete any remaining helm releases in mercury namespace
helm -n mercury uninstall internal-issue-report-apiv1 --ignore-not-found 2>/dev/null || true
helm -n mercury uninstall internal-issue-report-apiv2 --ignore-not-found 2>/dev/null || true
helm -n mercury uninstall internal-issue-report-apache --ignore-not-found 2>/dev/null || true
helm -n mercury uninstall internal-issue-report-daniel --ignore-not-found 2>/dev/null || true

# Delete any remaining kubernetes resources
kubectl -n mercury delete all --all --ignore-not-found=true
kubectl delete ns mercury --ignore-not-found=true

# Note: We keep the mercury namespace as it might be used by other exercises

echo "Cleanup complete for Question 4"
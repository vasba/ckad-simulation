#!/bin/bash

# Question 4 - Helm Management Setup
# Sets up the environment for the Helm management exercise

echo "Setting up Question 4 - Helm Management exercise..."

# Create mercury namespace
kubectl create namespace mercury --dry-run=client -o yaml | kubectl apply -f -

# Note: In a real scenario, you would need to:
# 1. Add bitnami helm repo: helm repo add bitnami https://charts.bitnami.com/bitnami
# 2. Install initial releases for the exercise
# 3. Create a broken release in pending-install state

# For simulation purposes, we'll create some mock releases
# Students would need a working Helm installation and bitnami repo

echo "Setup complete for Question 4"
echo "IMPORTANT: This exercise requires Helm to be installed and configured"
echo "Students should have bitnami repo added: helm repo add bitnami https://charts.bitnami.com/bitnami"
echo ""
echo "To fully test this exercise, you would need to pre-install:"
echo "1. helm -n mercury install internal-issue-report-apiv1 bitnami/nginx"
echo "2. helm -n mercury install internal-issue-report-apiv2 bitnami/nginx"
echo "3. Create a broken release in pending-install state"
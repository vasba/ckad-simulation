#!/bin/bash

# Question 4 - Helm Management Setup
# Sets up the environment for the Helm management exercise

echo "Setting up Question 4 - Helm Management exercise..."

# Create mercury namespace
kubectl create namespace mercury --dry-run=client -o yaml | kubectl apply -f -

# Add bitnami helm repo (assuming helm is installed)
echo "Adding bitnami helm repository..."
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

# Install required releases for the exercise
echo "Installing initial Helm releases..."

# Install internal-issue-report-apiv1 (to be deleted by student)
helm -n mercury install internal-issue-report-apiv1 bitnami/nginx

# Install internal-issue-report-apiv2 (to be upgraded by student)
helm -n mercury install internal-issue-report-apiv2 bitnami/nginx

# Create a broken release in pending-install state (to be found and deleted by student)  
# echo "Creating a broken release in pending-install state..."

# Install invalid chart with pre-install hook that hangs
# helm -n mercury install internal-issue-report-daniel invalid_chart || true



echo ""
echo "Setup complete for Question 4"
echo "Created releases in mercury namespace:"
echo "- internal-issue-report-apiv1 (for deletion)"
echo "- internal-issue-report-apiv2 (for upgrade)" 
echo "- internal-issue-report-daniel (broken/pending-install state)"
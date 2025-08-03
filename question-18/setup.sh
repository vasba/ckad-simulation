#!/bin/bash

# Question 18 - Ingress Setup
# Creates the environment for the ingress exercise

echo "Setting up Question 18 - Ingress exercise..."

# Create venus namespace
kubectl create namespace venus --dry-run=client -o yaml | kubectl apply -f -

# Create the course directory
sudo mkdir -p /opt/course/18

echo "Setup complete for Question 18"
echo "Venus namespace created"
echo "Student should create pods, services, and ingress"

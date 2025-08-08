#!/bin/bash

# Question 10 - Service, Logs Setup
# Creates the Pod and Service for testing

echo "Setting up Question 10 - Service, Logs exercise..."

# Create pluto namespace if it doesn't exist
kubectl create namespace pluto --dry-run=client -o yaml | kubectl apply -f -
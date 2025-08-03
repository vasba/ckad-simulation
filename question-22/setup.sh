#!/bin/bash

# Question 22 - Multi-container Pod Setup
# Creates the environment for the multi-container pod exercise

echo "Setting up Question 22 - Multi-container Pod exercise..."

# Create cosmos namespace
kubectl create namespace cosmos --dry-run=client -o yaml | kubectl apply -f -

# Create the course directory
mkdir -p $HOME/ckad-simulation/22

echo "Setup complete for Question 22"
echo "Cosmos namespace created"
echo "Student should create multi-container pod with init container and sidecar"

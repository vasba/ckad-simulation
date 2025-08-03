#!/bin/bash

# Question 19 - Resource Requirements Setup
# Creates the environment for the resource limits exercise

echo "Setting up Question 19 - Resource Requirements exercise..."

# Create mars namespace
kubectl create namespace mars --dry-run=client -o yaml | kubectl apply -f -

# Create the course directory
mkdir -p $HOME/ckad-simulation/19

echo "Setup complete for Question 19"
echo "Mars namespace created"
echo "Student should create deployment with resource requests/limits and probes"

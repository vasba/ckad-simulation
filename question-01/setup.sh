#!/bin/bash

# Question 1 - Namespaces Setup
# Creates the necessary namespaces for the exercise

echo "Setting up Question 1 - Namespaces exercise..."

# Create the required namespaces (these would typically exist in a cluster)
kubectl create namespace earth --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace jupiter --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace mars --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace shell-intern --dry-run=client -o yaml | kubectl apply -f -

# Create the target directory (simulate being on ckad5601)
mkdir -p $HOME/ckad-simulation/1

echo "Setup complete for Question 1"
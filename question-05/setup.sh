#!/bin/bash

# Question 5 - ServiceAccount, Secret Setup
# Sets up the environment for the ServiceAccount and Secret exercise

echo "Setting up Question 5 - ServiceAccount, Secret exercise..."

# Create neptune namespace if it doesn't exist
kubectl create namespace neptune --dry-run=client -o yaml | kubectl apply -f -

# Create the ServiceAccount
kubectl apply -f serviceaccount.yaml

# Create the Secret with the service account annotation
kubectl apply -f secret.yaml

# Create the target directory (simulate being on ckad7326)
mkdir -p $HOME/ckad-simulation/5

echo "Setup complete for Question 5"
#!/bin/bash

# Question 13 - Storage, StorageClass, PVC Setup
# Creates environment for this exercise

echo "Setting up Question 13 - Storage, StorageClass, PVC exercise..."

# Create moon namespace
kubectl create namespace moon --dry-run=client -o yaml | kubectl apply -f -

# Create the course directory
mkdir -p $HOME/ckad-simulation/13

echo "Setup complete for Question 13"
echo "Student should create StorageClass 'moon-retain' and PVC 'moon-pvc-126'"
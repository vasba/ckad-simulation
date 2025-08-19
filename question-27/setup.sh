#!/bin/bash

# Question 27 - Labels, Annotations Setup
# Creates the necessary pods with various labels for the labels and annotations exercise

echo "Setting up Question 27 - Labels, Annotations exercise..."

# Create the target directory (simulate being on ckad9043)
mkdir -p $HOME/ckad-simulation/27

# Create the sun namespace
kubectl create namespace sun --dry-run=client -o yaml | kubectl apply -f -

# Create various pods with different labels to simulate the environment
echo "Creating pods with different labels..."

# Pods with type=worker labels
kubectl run 0509649b --image=nginx:alpine -n sun --labels="type=worker" 
kubectl run 1428721e --image=nginx:alpine -n sun --labels="type=worker"
kubectl run 1428721f --image=nginx:alpine -n sun --labels="type=worker"
kubectl run 4c09 --image=nginx:alpine -n sun --labels="type=worker"
kubectl run 4c35 --image=nginx:alpine -n sun --labels="type=worker"
kubectl run 4fe4 --image=nginx:alpine -n sun --labels="type=worker"
kubectl run afd79200c56a --image=nginx:alpine -n sun --labels="type=worker"
kubectl run b667 --image=nginx:alpine -n sun --labels="type=worker"
kubectl run fdb2 --image=nginx:alpine -n sun --labels="type=worker"

# Pods with type=runner labels
kubectl run 0509649a --image=nginx:alpine -n sun --labels="type=runner,type_old=messenger"
kubectl run 86cda --image=nginx:alpine -n sun --labels="type=runner"
kubectl run a004a --image=nginx:alpine -n sun --labels="type=runner"
kubectl run a94128196 --image=nginx:alpine -n sun --labels="type=runner,type_old=messenger"

# Pods with other labels (should NOT get the protected label)
kubectl run 43b9a --image=nginx:alpine -n sun --labels="type=test"
kubectl run 5555a --image=nginx:alpine -n sun --labels="type=messenger"
kubectl run 8d1c --image=nginx:alpine -n sun --labels="type=messenger"

# Wait for all pods to be running
echo "⏳ Waiting for all pods to be running..."
kubectl wait --for=condition=Ready pod --all -n sun --timeout=60s

echo "Setup complete for Question 27"
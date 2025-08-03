#!/bin/bash

# Question 21 - SecurityContext Setup
# Creates the environment for the security context exercise

echo "Setting up Question 21 - SecurityContext exercise..."

# Create galaxy namespace
kubectl create namespace galaxy --dry-run=client -o yaml | kubectl apply -f -

# Create the course directory
sudo mkdir -p /opt/course/21

echo "Setup complete for Question 21"
echo "Galaxy namespace created"
echo "Student should create secure pod with proper security contexts"

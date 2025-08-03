#!/bin/bash

# Question 3 - Job Setup
# Sets up the environment for the Job exercise

echo "Setting up Question 3 - Job exercise..."

# Create neptune namespace
kubectl create namespace neptune --dry-run=client -o yaml | kubectl apply -f -

# Create the target directory (simulate being on ckad7326)
mkdir -p /opt/course/3

# Copy the job template to the expected location
cp job.yaml /opt/course/3/job.yaml

echo "Setup complete for Question 3"
echo "Student should:"
echo "1. Review the job.yaml template at /opt/course/3/job.yaml"
echo "2. Create the job using: kubectl -f /opt/course/3/job.yaml create"
echo "3. Check job status with: kubectl -n neptune get job,pod"
#!/bin/bash

# Question 20 - CronJob Setup
# Creates the environment for the cronjob exercise

echo "Setting up Question 20 - CronJob exercise..."

# Create jupiter namespace
kubectl create namespace jupiter --dry-run=client -o yaml | kubectl apply -f -

# Create the course directory
sudo mkdir -p /opt/course/20

echo "Setup complete for Question 20"
echo "Jupiter namespace created"
echo "Student should create CronJob for scheduled backup"

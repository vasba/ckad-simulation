#!/bin/bash

# Question 11 - Working with Containers Cleanup
# Removes all resources created for this exercise

echo "Cleaning up Question 11 - Working with Containers exercise..."

# Stop and remove the container if running
sudo podman stop sun-cipher --ignore 2>/dev/null
sudo podman rm sun-cipher --ignore 2>/dev/null

# Remove the images if they exist
sudo podman rmi registry.killer.sh:5000/sun-cipher:v1-podman --ignore 2>/dev/null
sudo docker rmi registry.killer.sh:5000/sun-cipher:v1-docker --ignore 2>/dev/null

# Clean up the course directory
rm -rf $HOME/ckad-simulation/11

echo "Cleanup complete for Question 11"
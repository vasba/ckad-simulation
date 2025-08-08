#!/bin/bash

# Question 11 - Working with Containers Setup
# Creates the container build environment for Python application

echo "Setting up Question 11 - Working with Containers exercise..."

# Create the course directory
mkdir -p $HOME/ckad-simulation/11/image

# Create a simple Python application
cat <<EOF > $HOME/ckad-simulation/11/image/app.py
import os
import time
import random
from datetime import datetime

def main():
    cipher_id = os.environ.get('SUN_CIPHER_ID', 'default-cipher-id')
    
    while True:
        random_num = random.randint(0, 9999)
        timestamp = datetime.now().strftime('%Y/%m/%d %H:%M:%S')
        print(f"{timestamp} random number for {cipher_id} is {random_num}")
        time.sleep(1)

if __name__ == "__main__":
    main()
EOF

# Create Dockerfile
cat <<EOF > $HOME/ckad-simulation/11/image/Dockerfile
FROM docker.io/library/python:3.9-alpine
WORKDIR /app
COPY app.py .
# CHANGE NEXT LINE
ENV SUN_CIPHER_ID=placeholder-value
CMD ["python", "app.py"]
EOF

echo "Setup complete for Question 11"
echo "Container build files created at $HOME/ckad-simulation/11/image/"
echo "Dockerfile contains placeholder ENV variable that needs to be changed"
echo "Use 'cd $HOME/ckad-simulation/11/image && sudo docker build .' to test build"
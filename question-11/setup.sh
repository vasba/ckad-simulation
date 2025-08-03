#!/bin/bash

# Question 11 - Working w# Create a Dockerfile
cat <<EOF > $HOME/ckad-simulation/11/image/Dockerfileh Containers Setup
# Creates the container build environment

echo "Setting up Question 11 - Working with Containers exercise..."

# Create the course directory
mkdir -p $HOME/ckad-simulation/11/image

# Create a simple Golang application
cat <<EOF > $HOME/ckad-simulation/11/image/main.go
package main

import (
    "fmt"
    "os"
    "time"
    "math/rand"
)

func main() {
    cipherID := os.Getenv("SUN_CIPHER_ID")
    if cipherID == "" {
        cipherID = "default-cipher-id"
    }
    
    rand.Seed(time.Now().UnixNano())
    
    for {
        randomNum := rand.Intn(10000)
        fmt.Printf("%s random number for %s is %d\\n", 
            time.Now().Format("2006/01/02 15:04:05"), cipherID, randomNum)
        time.Sleep(1 * time.Second)
    }
}
EOF

# Create Dockerfile
cat <<EOF > /opt/course/11/image/Dockerfile
# build container stage 1
FROM docker.io/library/golang:1.15.15-alpine3.14
WORKDIR /src
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o bin/app .

# app container stage 2
FROM docker.io/library/alpine:3.12.4
COPY --from=0 /src/bin/app app
# CHANGE NEXT LINE
ENV SUN_CIPHER_ID=placeholder-value
CMD ["./app"]
EOF

echo "Setup complete for Question 11"
echo "Container build files created at $HOME/ckad-simulation/11/image/"
echo "Dockerfile contains placeholder ENV variable that needs to be changed"
echo "Use 'cd $HOME/ckad-simulation/11/image && sudo docker build .' to test build"
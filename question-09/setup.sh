#!/bin/bash

# Question 9 - Pod -> Deployment Setup
# Creates the scenario with a single Pod that needs to be converted

echo "Setting up Question 9 - Pod -> Deployment exercise..."

# Create pluto namespace if it doesn't exist
kubectl create namespace pluto --dry-run=client -o yaml | kubectl apply -f -

# Create the course directory
mkdir -p /opt/course/9

# Create the original holy-api Pod
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  labels:
    id: holy-api
    name: holy-api
  name: holy-api
  namespace: pluto
spec:
  containers:
  - env:
    - name: CACHE_KEY_1
      value: "b&MTCi0=[T66RXm!jO@"
    - name: CACHE_KEY_2
      value: "PCAILGej5Ld@Q%{Q1=#"
    - name: CACHE_KEY_3
      value: "2qz-]2OJlWDSTn_;RFQ"
    image: nginx:1.17.3-alpine
    name: holy-api-container
    volumeMounts:
    - mountPath: /cache1
      name: cache-volume1
    - mountPath: /cache2
      name: cache-volume2
    - mountPath: /cache3
      name: cache-volume3
  volumes:
  - emptyDir: {}
    name: cache-volume1
  - emptyDir: {}
    name: cache-volume2
  - emptyDir: {}
    name: cache-volume3
EOF

# Create the Pod template file
cat <<EOF > /opt/course/9/holy-api-pod.yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
    id: holy-api
    name: holy-api
  name: holy-api
  namespace: pluto
spec:
  containers:
  - env:
    - name: CACHE_KEY_1
      value: "b&MTCi0=[T66RXm!jO@"
    - name: CACHE_KEY_2
      value: "PCAILGej5Ld@Q%{Q1=#"
    - name: CACHE_KEY_3
      value: "2qz-]2OJlWDSTn_;RFQ"
    image: nginx:1.17.3-alpine
    name: holy-api-container
    volumeMounts:
    - mountPath: /cache1
      name: cache-volume1
    - mountPath: /cache2
      name: cache-volume2
    - mountPath: /cache3
      name: cache-volume3
  volumes:
  - emptyDir: {}
    name: cache-volume1
  - emptyDir: {}
    name: cache-volume2
  - emptyDir: {}
    name: cache-volume3
EOF

echo "Setup complete for Question 9"
echo "Pod holy-api created in pluto namespace"
echo "Pod template available at /opt/course/9/holy-api-pod.yaml"
echo "Use 'kubectl -n pluto get pod holy-api' to see the Pod"
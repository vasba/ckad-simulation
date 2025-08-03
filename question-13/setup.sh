#!/bin/bash

# Question 13 - Storage, StorageClass, PVC Setup
# Creates all resources needed for this exercise

echo "Setting up Question 13 - Storage, StorageClass, PVC exercise..."

# Create moon namespace
kubectl create namespace moon --dry-run=client -o yaml | kubectl apply -f -

# Create the StorageClass
cat <<EOF | kubectl apply -f -
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: moon-retain
provisioner: moon-retainer
reclaimPolicy: Retain
EOF

# Create the PersistentVolumeClaim
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: moon-pvc-126
  namespace: moon
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 3Gi
  storageClassName: moon-retain
EOF

# Create the course directory
sudo mkdir -p /opt/course/13

echo "Setup complete for Question 13"
echo "Note: PVC will remain Pending because provisioner 'moon-retainer' doesn't exist yet"
#!/bin/bash

# Question 12 - Storage, PV, PVC, Pod volume Setup
# Creates the storage resources

echo "Setting up Question 12 - Storage, PV, PVC, Pod volume exercise..."

# Create earth namespace if it doesn't exist
kubectl create namespace earth --dry-run=client -o yaml | kubectl apply -f -

# Create the host directory (simulate the hostPath)
sudo mkdir -p /Volumes/Data

# Create the PersistentVolume
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: PersistentVolume
metadata:
  name: earth-project-earthflower-pv
spec:
  capacity:
    storage: 2Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: "/Volumes/Data"
EOF

# Create the PersistentVolumeClaim
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: earth-project-earthflower-pvc
  namespace: earth
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 2Gi
EOF

# Wait for PVC to bind to PV
echo "Waiting for PVC to bind to PV..."
kubectl -n earth wait --for=jsonpath='{.status.phase}'=Bound pvc/earth-project-earthflower-pvc --timeout=60s

echo "Setup complete for Question 12"
echo "PV and PVC created and bound"
echo "Use 'kubectl -n earth get pv,pvc' to check status"
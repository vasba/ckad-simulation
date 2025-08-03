#!/bin/bash

# Question 6 - ReadinessProbe Setup
# Creates the Pod with readiness probe

echo "Setting up Question 6 - ReadinessProbe exercise..."

# Create the Pod YAML
cat <<EOF > pod6.yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: pod6
  name: pod6
spec:
  containers:
  - command:
    - sh
    - -c
    - touch /tmp/ready && sleep 1d
    image: busybox:1.31.0
    name: pod6
    readinessProbe:
      exec:
        command:
        - sh
        - -c
        - cat /tmp/ready
      initialDelaySeconds: 5
      periodSeconds: 10
  dnsPolicy: ClusterFirst
  restartPolicy: Always
EOF

# Create the Pod
kubectl create -f pod6.yaml

echo "Setup complete for Question 6"
echo "Pod pod6 created with readiness probe"
echo "Use 'kubectl get pod pod6' to check status"
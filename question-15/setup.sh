#!/bin/bash

# Question 15 - ConfigMap, Configmap-Volume Setup
# Creates all resources needed for this exercise

echo "Setting up Question 15 - ConfigMap, Configmap-Volume exercise..."

# Create moon namespace
kubectl create namespace moon --dry-run=client -o yaml | kubectl apply -f -

# Create the course directory
sudo mkdir -p /opt/course/15

# Create the web-moon.html file
cat <<EOF > /opt/course/15/web-moon.html
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Web Moon Webpage</title>
</head>
<body>
This is some great content.
</body>
</html>
EOF

# Create the nginx Deployment that expects the ConfigMap
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-moon
  namespace: moon
spec:
  replicas: 5
  selector:
    matchLabels:
      app: web-moon
  template:
    metadata:
      labels:
        app: web-moon
    spec:
      containers:
      - name: nginx
        image: nginx:1.21.1-alpine
        ports:
        - containerPort: 80
        volumeMounts:
        - name: html-volume
          mountPath: /usr/share/nginx/html
          readOnly: true
      volumes:
      - name: html-volume
        configMap:
          name: configmap-web-moon-html
EOF

echo "Setup complete for Question 15"
echo "File created: /opt/course/15/web-moon.html"
echo "Deployment 'web-moon' created but will fail until ConfigMap is created"
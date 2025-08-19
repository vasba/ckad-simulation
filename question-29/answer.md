# Answer - Question 29 | Deployment with ServiceAccount and Service

Based on Preview Question 2 from the Killer Shell exam simulator.

## Problem
Team Sun needs a new Deployment named `sunny` with 4 replicas of image `nginx:1.17.3-alpine` in Namespace `sun`. The Deployment and its Pods should use the existing ServiceAccount `sa-sun-deploy`.

Create a ClusterIP Service named `sun-srv` which exposes the Deployment on port 9999. The target port should be the default port the nginx container is using.

Finally, create a new file `/opt/course/29/list.sh` which shows all resources of Namespace `sun`, but in the form of a list and not in columns.

## Steps to solve:

1. **Check the namespace and ServiceAccount**:
```bash
kubectl get ns sun
kubectl get sa sa-sun-deploy -n sun
```

2. **Create the deployment**:
```bash
# Method 1: Create directly with YAML
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: sunny
  namespace: sun
spec:
  replicas: 4
  selector:
    matchLabels:
      app: sunny
  template:
    metadata:
      labels:
        app: sunny
    spec:
      serviceAccountName: sa-sun-deploy
      containers:
      - name: nginx
        image: nginx:1.17.3-alpine
        ports:
        - containerPort: 80
EOF
```

```bash
# Method 2: Create with imperative command and edit
kubectl create deployment sunny --image=nginx:1.17.3-alpine --replicas=4 -n sun
kubectl patch deployment sunny -n sun -p '{"spec":{"template":{"spec":{"serviceAccountName":"sa-sun-deploy"}}}}'
```

3. **Verify the deployment**:
```bash
kubectl get deployment sunny -n sun
kubectl get pods -n sun -l app=sunny
```

4. **Create the ClusterIP service**:
```bash
kubectl expose deployment sunny --name=sun-srv --port=9999 --target-port=80 -n sun
```

Or using YAML:
```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: sun-srv
  namespace: sun
spec:
  type: ClusterIP
  selector:
    app: sunny
  ports:
  - port: 9999
    targetPort: 80
    protocol: TCP
EOF
```

5. **Verify the service**:
```bash
kubectl get service sun-srv -n sun
kubectl describe service sun-srv -n sun
```

6. **Create the list.sh script**:
```bash
cat <<'EOF' > /opt/course/29/list.sh
#!/bin/bash
kubectl get all -n sun -o wide --no-headers
EOF
```

Make it executable:
```bash
chmod +x /opt/course/29/list.sh
```

7. **Test the script**:
```bash
bash /opt/course/29/list.sh
```

8. **Final verification**:
```bash
# Check all resources
kubectl get all -n sun

# Test service connectivity
kubectl run test-pod --restart=Never --rm -i --image=busybox:1.35 -- wget -qO- sun-srv.sun.svc.cluster.local:9999
```

## Alternative Solutions:

### For the deployment YAML file:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: sunny
  namespace: sun
  labels:
    app: sunny
spec:
  replicas: 4
  selector:
    matchLabels:
      app: sunny
  template:
    metadata:
      labels:
        app: sunny
    spec:
      serviceAccountName: sa-sun-deploy
      containers:
      - name: nginx
        image: nginx:1.17.3-alpine
        ports:
        - containerPort: 80
        resources:
          requests:
            memory: "64Mi"
            cpu: "50m"
          limits:
            memory: "128Mi"
            cpu: "100m"
```

### For the script variations:
```bash
# Option 1: Simple list format
echo '#!/bin/bash' > /opt/course/29/list.sh
echo 'kubectl get all -n sun -o wide' >> /opt/course/29/list.sh

# Option 2: More detailed list
echo '#!/bin/bash' > /opt/course/29/list.sh  
echo 'kubectl get all -n sun -o custom-columns="NAME:.metadata.name,TYPE:.kind,STATUS:.status.phase"' >> /opt/course/29/list.sh

# Option 3: One-liner list format
echo 'kubectl get all -n sun -o name' > /opt/course/29/list.sh
```

## Key Learning Points:

### Deployments with ServiceAccounts:
- **ServiceAccount Field**: Use `spec.template.spec.serviceAccountName` in Deployment
- **Pod Identity**: ServiceAccount provides identity for pods to interact with Kubernetes API
- **Security Context**: ServiceAccounts are part of Kubernetes RBAC

### Service Port Mapping:
- **Service Port**: Port exposed by the service (9999 in this case)
- **Target Port**: Port on the pod/container (80 for nginx)
- **Container Port**: Port the application listens on (80 for nginx default)

### ClusterIP Services:
- **Internal Only**: Only accessible within the cluster
- **Stable Endpoint**: Provides stable IP and DNS name for pods
- **Load Balancing**: Automatically distributes traffic across healthy pods

### kubectl Output Formats:
- **Wide**: `kubectl get all -o wide` shows additional columns
- **List vs Columns**: List format shows one item per line
- **Custom Columns**: Can customize output with `-o custom-columns`

### Best Practices:
- **Label Consistency**: Ensure deployment labels match service selectors
- **Resource Limits**: Always set resource requests and limits in production
- **Health Checks**: Add readiness and liveness probes for production workloads
- **Script Permissions**: Make shell scripts executable with `chmod +x`

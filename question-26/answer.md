# Answer - Question 26 | Requests and Limits, ServiceAccount

Based on Question 21 from the Killer Shell exam simulator.

## Problem
Team Neptune needs 3 Pods of image `httpd:2.4-alpine`, create a Deployment named `neptune-10ab`. The containers should be named `neptune-pod-10ab`. Each container should have a memory request of 20Mi and a memory limit of 50Mi. Team Neptune has its own ServiceAccount `neptune-sa-v2` under which the Pods should run. The Deployment should be in Namespace `neptune`.

## Steps to solve:

1. **Create the deployment template**:
```bash
kubectl -n neptune create deploy neptune-10ab --replicas=3 --image=httpd:2.4-alpine --dry-run=client -oyaml > 26.yaml
```

2. **Edit the YAML file**:
```bash
vim 26.yaml
```

Modify the YAML to include all required specifications:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: neptune-10ab
  name: neptune-10ab
  namespace: neptune
spec:
  replicas: 3
  selector:
    matchLabels:
      app: neptune-10ab
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: neptune-10ab
    spec:
      serviceAccountName: neptune-sa-v2  # ADD this line
      containers:
      - image: httpd:2.4-alpine
        name: neptune-pod-10ab            # CHANGE from default name
        resources:                        # ADD resources section
          limits:                         # ADD limits
            memory: 50Mi                  # ADD memory limit
          requests:                       # ADD requests  
            memory: 20Mi                  # ADD memory request
status: {}
```

3. **Create the deployment**:
```bash
kubectl create -f 26.yaml
```

4. **Verify the deployment**:
```bash
kubectl -n neptune get pod
```

Expected output should show 3 running pods:
```
NAME                            READY   STATUS    RESTARTS   AGE
neptune-10ab-7d4b8d45b-4nzj5    1/1     Running   0          57s
neptune-10ab-7d4b8d45b-lzwrf    1/1     Running   0          17s  
neptune-10ab-7d4b8d45b-z5hcc    1/1     Running   0          17s
```

5. **Verify resource configuration** (optional):
```bash
kubectl -n neptune describe deployment neptune-10ab
```

6. **Verify ServiceAccount usage** (optional):
```bash
kubectl -n neptune get pods -l app=neptune-10ab -o jsonpath='{.items[0].spec.serviceAccountName}'
```

## Key Learning Points:

### Resource Management:
- **Requests**: Minimum amount of resources guaranteed to the container
- **Limits**: Maximum amount of resources the container can use
- **Memory units**: Use Mi for mebibytes (1024-based), MB for megabytes (1000-based)
- **Best practice**: Always set both requests and limits for predictable behavior

### ServiceAccounts:
- **ServiceAccount**: Provides an identity for processes running in a Pod
- **Default behavior**: If not specified, pods use the `default` ServiceAccount
- **Custom ServiceAccounts**: Allow fine-grained permissions and security policies
- **Usage**: Set via `spec.serviceAccountName` in the Pod template

### Deployment Configuration:
- **Replicas**: Number of desired pod instances
- **Container names**: Can be customized from the default image name
- **Template specification**: Pod template within deployment defines the actual pod configuration

## Resource Specifications Format:
```yaml
resources:
  limits:
    memory: "50Mi"    # Maximum memory
    cpu: "500m"       # Maximum CPU (500 millicores)
  requests:
    memory: "20Mi"    # Requested memory
    cpu: "100m"       # Requested CPU (100 millicores)
```

## Common Resource Units:
- **CPU**: `100m` (100 millicores), `0.5` (500 millicores), `1` (1 core)
- **Memory**: `128Mi`, `1Gi`, `512M`, `1G`

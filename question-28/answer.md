# Answer - Question 28 | Liveness Probe

Based on Preview Question 1 from the Killer Shell exam simulator.

## Problem
In Namespace pluto there is a Deployment named project-23-api. It needs a liveness-probe which checks the container to be reachable on port 80. Initially the probe should wait 10, periodically 15 seconds.

## Steps to solve:

1. **First, examine the current deployment**:
```bash
kubectl -n pluto get all -o wide
```

2. **Test connectivity to ensure pods are working** (optional):
```bash
# Get a pod IP
kubectl -n pluto get pods -o wide

# Test with curl
kubectl run tmp --restart=Never --rm -i --image=nginx:alpine -- curl -m 5 [POD_IP]
```

3. **Copy the original deployment file**:
```bash
cp $HOME/ckad-simulation/28/project-23-api.yaml $HOME/ckad-simulation/28/project-23-api-new.yaml
```

4. **Edit the new file to add liveness probe**:
```bash
vim $HOME/ckad-simulation/28/project-23-api-new.yaml
```

Add the liveness probe to the container specification:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: project-23-api
  namespace: pluto
spec:
  replicas: 3
  selector:
    matchLabels:
      app: project-23-api
  template:
    metadata:
      labels:
        app: project-23-api
    spec:
      volumes:
      - name: cache-volume1
        emptyDir: {}
      - name: cache-volume2
        emptyDir: {}
      - name: cache-volume3
        emptyDir: {}
      containers:
      - image: httpd:2.4-alpine
        name: httpd
        volumeMounts:
        - mountPath: /cache1
          name: cache-volume1
        - mountPath: /cache2
          name: cache-volume2
        - mountPath: /cache3
          name: cache-volume3
        env:
        - name: APP_ENV
          value: "prod"
        - name: APP_SECRET_N1
          value: "IO=a4L/XkRdvN8jM=Y+"
        - name: APP_SECRET_P1
          value: "-7PA0_Z]>{pwa43r)__"
        livenessProbe:                    # ADD this section
          tcpSocket:                      # ADD
            port: 80                      # ADD
          initialDelaySeconds: 10         # ADD
          periodSeconds: 15               # ADD
```

5. **Apply the changes**:
```bash
kubectl apply -f $HOME/ckad-simulation/28/project-23-api-new.yaml
```

6. **Wait and verify the deployment is still running**:
```bash
kubectl -n pluto get pod
```

7. **Verify the liveness probe configuration**:
```bash
# Check on a pod
kubectl -n pluto describe pod [pod-name] | grep Liveness

# Or check on the deployment
kubectl -n pluto describe deploy project-23-api | grep Liveness
```

Expected output:
```
Liveness: tcp-socket :80 delay=10s timeout=1s period=15s #success=1 #failure=3
```

## Key Learning Points:

### Liveness Probes:
- **Purpose**: Kubernetes uses liveness probes to know when to restart a container
- **Failure action**: If a liveness probe fails, Kubernetes kills the container and restarts it
- **Use cases**: Applications that may hang or become unresponsive

### Probe Types:
1. **HTTP GET**: `httpGet` with path, port, and optional headers
2. **TCP Socket**: `tcpSocket` with port (used in this exercise)
3. **Exec Command**: `exec` with command to execute inside container

### Probe Configuration:
- **initialDelaySeconds**: Wait before first probe (10 seconds in this case)
- **periodSeconds**: How often to perform the probe (15 seconds in this case)  
- **timeoutSeconds**: Timeout for the probe (default: 1 second)
- **failureThreshold**: Number of failures before restart (default: 3)
- **successThreshold**: Number of successes to consider healthy (default: 1)

### TCP Socket Probe:
```yaml
livenessProbe:
  tcpSocket:
    port: 80                    # Port to check
  initialDelaySeconds: 10       # Wait 10s before first check
  periodSeconds: 15             # Check every 15s
```

### HTTP GET Probe Alternative:
```yaml
livenessProbe:
  httpGet:
    path: /
    port: 80
  initialDelaySeconds: 10
  periodSeconds: 15
```

### Best Practices:
- **Set appropriate delays**: Allow time for application startup
- **Choose the right probe type**: TCP for port availability, HTTP for application health
- **Avoid too frequent checks**: Can create unnecessary load
- **Test probe configuration**: Ensure it doesn't cause unnecessary restarts

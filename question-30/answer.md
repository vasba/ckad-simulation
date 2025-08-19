# Answer - Question 30 | Service Troubleshooting

Based on Preview Question 3 from the Killer Shell exam simulator.

## Problem
There is a Deployment named `holy` and a Service named `holy-srv` in Namespace `earth`. The Pod(s) of that Deployment are not reachable via the Service.

Identify the problem and fix it. Write the reason into file `/opt/course/30/ticket.txt`.

## Steps to solve:

1. **First, examine the current state**:
```bash
kubectl get all -n earth
kubectl get pods -n earth -o wide
kubectl get endpoints holy-srv -n earth
```

2. **Check service configuration**:
```bash
kubectl describe service holy-srv -n earth
```

3. **Check deployment details**:
```bash
kubectl describe deployment holy -n earth
kubectl describe pods -n earth -l app=holy
```

4. **Identify the problem**:
The issue is that the readiness probe is configured to check port 82, but nginx runs on port 80:

```bash
# Check the readiness probe configuration
kubectl get deployment holy -n earth -o yaml | grep -A 10 readinessProbe
```

You'll see:
```yaml
readinessProbe:
  httpGet:
    path: /
    port: 82    # This is wrong! Should be 80
```

5. **Fix the deployment**:
```bash
kubectl edit deployment holy -n earth
```

Change the readiness probe port from 82 to 80:
```yaml
readinessProbe:
  httpGet:
    path: /
    port: 80    # Fixed!
  initialDelaySeconds: 5
  periodSeconds: 5
```

Or use kubectl patch:
```bash
kubectl patch deployment holy -n earth -p '{"spec":{"template":{"spec":{"containers":[{"name":"nginx","readinessProbe":{"httpGet":{"port":80}}}]}}}}'
```

6. **Wait for pods to become ready**:
```bash
kubectl get pods -n earth -w
```

7. **Verify the fix**:
```bash
# Check endpoints are now populated
kubectl get endpoints holy-srv -n earth

# Test service connectivity
kubectl run test-pod --restart=Never --rm -i --image=busybox:1.35 -- wget -qO- holy-srv.earth.svc.cluster.local
```

8. **Write the ticket explanation**:
```bash
cat > /opt/course/30/ticket.txt << 'EOF'
The readiness probe was configured to check port 82, but the nginx container runs on port 80.
This caused the readiness probe to always fail, so the pods never became "Ready".
When pods are not ready, they are not added to service endpoints, making the service unreachable.
Fixed by changing readiness probe port from 82 to 80.
EOF
```

## Root Cause Analysis:

### The Problem:
- **Readiness Probe Misconfiguration**: The probe was checking port 82 instead of 80
- **No Ready Pods**: Failed readiness probes kept pods in "Not Ready" state  
- **No Service Endpoints**: Kubernetes only adds "Ready" pods to service endpoints
- **Service Unreachable**: With no endpoints, the service had nowhere to route traffic

### The Solution:
- **Fix Probe Port**: Changed readiness probe from port 82 to port 80
- **Pods Become Ready**: Successful probes allow pods to pass readiness checks
- **Endpoints Populated**: Ready pods are automatically added to service endpoints
- **Service Works**: Traffic can now be routed to healthy pods

## Key Learning Points:

### Readiness vs Liveness Probes:
- **Readiness Probe**: Determines if pod should receive traffic (affects service endpoints)
- **Liveness Probe**: Determines if pod should be restarted
- **Failure Impact**: Failed readiness = no traffic, failed liveness = restart

### Service Endpoint Management:
- **Automatic**: Kubernetes automatically manages endpoints based on pod readiness
- **Label Matching**: Service selector must match pod labels
- **Health Dependency**: Only "Ready" pods become endpoints

### Common Service Issues:
1. **Label Mismatch**: Service selector doesn't match pod labels
2. **Wrong Ports**: Service targetPort doesn't match container port
3. **Failed Probes**: Readiness probes prevent pods from becoming ready
4. **Network Policies**: May block traffic between pods and services

### Troubleshooting Workflow:
```bash
# 1. Check service and pods exist
kubectl get all -n namespace

# 2. Check service has endpoints
kubectl get endpoints service-name -n namespace

# 3. If no endpoints, check pod readiness
kubectl get pods -n namespace -o wide

# 4. If pods not ready, check readiness probes
kubectl describe pod pod-name -n namespace

# 5. Check events for clues
kubectl get events -n namespace --sort-by='.lastTimestamp'
```

### Alternative Fixes:

#### Option 1: Remove readiness probe (if not needed):
```bash
kubectl patch deployment holy -n earth --type='json' -p='[{"op": "remove", "path": "/spec/template/spec/containers/0/readinessProbe"}]'
```

#### Option 2: Fix with complete YAML:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: holy
  namespace: earth
spec:
  replicas: 2
  selector:
    matchLabels:
      app: holy
  template:
    metadata:
      labels:
        app: holy
    spec:
      containers:
      - name: nginx
        image: nginx:1.21.6-alpine
        ports:
        - containerPort: 80
        readinessProbe:
          httpGet:
            path: /
            port: 80          # Correct port
          initialDelaySeconds: 5
          periodSeconds: 5
```

### Best Practices:
- **Test Probes**: Always verify probe configuration matches application ports
- **Monitor Endpoints**: Check service endpoints when troubleshooting connectivity
- **Use Consistent Labels**: Ensure service selectors match deployment labels
- **Document Issues**: Keep clear records of problems and solutions for future reference

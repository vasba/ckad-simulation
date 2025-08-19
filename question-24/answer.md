# Answer - Question 24 | Service misconfiguration

Based on Question 18 from the Killer Shell exam simulator.

## Problem
There is an issue in Namespace mars where the ClusterIP service `manager-api-svc` should make the Pods of Deployment `manager-api-deployment` available inside the cluster, but connectivity fails.

## Steps to solve:

1. **Test the issue** - Try to connect to the service:
```bash
kubectl run tmp --restart=Never --rm -i --image=nginx:alpine -- curl -m 5 manager-api-svc.mars:4444
```
This will timeout and fail.

2. **Get overview of resources**:
```bash
kubectl -n mars get all
```

3. **Test direct pod connectivity** to ensure pods work:
```bash
kubectl -n mars get pod -o wide  # Get pod IP
kubectl run tmp --restart=Never --rm -i --image=nginx:alpine -- curl -m 5 [POD_IP]
```
This should work, confirming pods are healthy.

4. **Check service endpoints**:
```bash
kubectl -n mars describe service manager-api-svc
# or
kubectl -n mars get endpoints
```
You'll notice the service has no endpoints.

5. **Identify the problem** - Check the service selector:
```bash
kubectl -n mars get service manager-api-svc -o yaml
```

The issue is in the service selector:
```yaml
spec:
  selector:
    id: manager-api-deployment  # WRONG! This doesn't match pod labels
```

6. **Check pod labels**:
```bash
kubectl -n mars get pods --show-labels
```
The pods have label `id: manager-api-pod`.

7. **Fix the service selector**:
```bash
kubectl -n mars edit service manager-api-svc
```

Change the selector from:
```yaml
selector:
  id: manager-api-deployment
```

To:
```yaml
selector:
  id: manager-api-pod
```

8. **Verify the fix** - Check endpoints again:
```bash
kubectl -n mars get endpoints
```
Now you should see the endpoints populated.

9. **Test connectivity again**:
```bash
kubectl run tmp --restart=Never --rm -i --image=nginx:alpine -- curl -m 5 manager-api-svc.mars:4444
```
This should now work and return the nginx welcome page.

## Key Learning Points:

- **Services select Pods directly**, not Deployments
- Service selectors must match the labels on the Pods, not the Deployment name
- When a Service has no endpoints, check the selector configuration
- Use `kubectl get endpoints` or `kubectl describe service` to troubleshoot connectivity issues
- Cross-namespace service access uses format: `service-name.namespace.svc.cluster.local` or short form `service-name.namespace`

## DNS Resolution Examples:
- Same namespace: `manager-api-svc:4444`
- Cross-namespace: `manager-api-svc.mars:4444`  
- Full FQDN: `manager-api-svc.mars.svc.cluster.local:4444`

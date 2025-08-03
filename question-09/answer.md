# Answer - Question 9 | Pod -> Deployment

1. Create the deployment based on the Pod template:
```bash
# Copy the Pod template
cp holy-api-pod.yaml holy-api-deployment.yaml

# Convert to Deployment structure
vim holy-api-deployment.yaml
```

2. The Deployment structure should include:
- `apiVersion: apps/v1`
- `kind: Deployment`
- 3 replicas
- Proper selector matching labels
- Pod template with original Pod spec
- Add security context with `allowPrivilegeEscalation: false` and `privileged: false`

3. Create the Deployment:
```bash
kubectl create -f holy-api-deployment.yaml
```

4. Delete the original Pod:
```bash
kubectl -n pluto delete pod holy-api --force --grace-period=0
```

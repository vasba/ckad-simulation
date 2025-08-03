# Question 9 | Pod -> Deployment

## Task
In Namespace `pluto` there is single Pod named `holy-api`. It has been working okay for a while now but Team Pluto needs it to be more reliable.

Convert the Pod into a Deployment named `holy-api` with 3 replicas and delete the single Pod once done. The raw Pod template file is available at `holy-api-pod.yaml`.

In addition, the new Deployment should set `allowPrivilegeEscalation: false` and `privileged: false` for the security context on container level.

Please create the Deployment and save its yaml under `holy-api-deployment.yaml`.

## Expected Answer

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
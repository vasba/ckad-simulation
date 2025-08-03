````markdown
# Question 21 | SecurityContext, PodSecurityContext

## Task
Team Galaxy needs to enhance security for their application. Create a Pod named `galaxy-secure` in Namespace `galaxy` with these security requirements:

1. Use image `nginx:1.21.1-alpine`
2. Set Pod-level security context:
   - Run as user ID 1000
   - Run as group ID 3000
   - Set fsGroup to 2000
3. Set container-level security context:
   - Run as non-root: true
   - Read-only root filesystem: true
   - Drop all capabilities and add only NET_BIND_SERVICE
   - allowPrivilegeEscalation: false
4. Mount a temporary volume at `/tmp` and `/var/cache/nginx` for nginx to write temporary files
5. Mount an emptyDir volume at `/var/run` for nginx runtime files

Save the Pod specification as `/opt/course/21/galaxy-secure-pod.yaml` and verify it runs successfully.

## Expected Answer

1. Create the Pod with security contexts:
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: galaxy-secure
  namespace: galaxy
spec:
  securityContext:
    runAsUser: 1000
    runAsGroup: 3000
    fsGroup: 2000
  containers:
  - name: nginx
    image: nginx:1.21.1-alpine
    securityContext:
      runAsNonRoot: true
      readOnlyRootFilesystem: true
      allowPrivilegeEscalation: false
      capabilities:
        drop:
        - ALL
        add:
        - NET_BIND_SERVICE
    volumeMounts:
    - name: tmp
      mountPath: /tmp
    - name: cache
      mountPath: /var/cache/nginx
    - name: run
      mountPath: /var/run
  volumes:
  - name: tmp
    emptyDir: {}
  - name: cache
    emptyDir: {}
  - name: run
    emptyDir: {}
```

2. Apply the Pod:
```bash
kubectl apply -f /opt/course/21/galaxy-secure-pod.yaml
```

3. Verify security context:
```bash
kubectl -n galaxy exec galaxy-secure -- id
kubectl -n galaxy exec galaxy-secure -- ls -la /tmp
```
````

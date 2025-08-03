# Answer - Question 21 | SecurityContext, PodSecurityContext

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

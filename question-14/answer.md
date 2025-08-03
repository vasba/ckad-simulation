# Answer - Question 14 | Secret, Secret-Volume, Secret-Env

1. Create Secret `secret1`:
```bash
kubectl -n moon create secret generic secret1 --from-literal=user=test --from-literal=pass=pwd
```

2. Create Secret from existing yaml:
```bash
kubectl apply -f /opt/course/14/secret2.yaml
```

3. Edit the Pod to use both Secrets:
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: secret-handler
  namespace: moon
spec:
  containers:
  - name: secret-handler
    image: busybox:1.31.0
    command: ['sh', '-c', 'sleep 1d']
    env:
    - name: SECRET1_USER
      valueFrom:
        secretKeyRef:
          name: secret1
          key: user
    - name: SECRET1_PASS
      valueFrom:
        secretKeyRef:
          name: secret1
          key: pass
    volumeMounts:
    - name: secret2-volume
      mountPath: /tmp/secret2
      readOnly: true
  volumes:
  - name: secret2-volume
    secret:
      secretName: secret2
```

4. Save the updated Pod configuration:
```bash
kubectl get pod secret-handler -n moon -o yaml > /opt/course/14/secret-handler-new.yaml
```

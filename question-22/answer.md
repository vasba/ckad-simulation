# Answer - Question 22 | Multi-container Pod (Sidecar, Init Container)

1. Create the multi-container Pod:
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: cosmos-app
  namespace: cosmos
  labels:
    app: cosmos-app
    tier: frontend
spec:
  initContainers:
  - name: cosmos-init
    image: busybox:1.31.0
    command:
    - sh
    - -c
    - "echo 'Initializing...' && sleep 5 && echo 'Init complete' > /shared/init-status"
    volumeMounts:
    - name: shared-data
      mountPath: /shared
  containers:
  - name: cosmos-main
    image: nginx:1.21.1-alpine
    env:
    - name: APP_NAME
      value: "cosmos-application"
    volumeMounts:
    - name: shared-data
      mountPath: /usr/share/nginx/html/shared
  - name: cosmos-sidecar
    image: busybox:1.31.0
    command:
    - sh
    - -c
    - "while true; do echo \"$(date): Sidecar monitoring...\" >> /shared/sidecar.log; sleep 30; done"
    volumeMounts:
    - name: shared-data
      mountPath: /shared
  volumes:
  - name: shared-data
    emptyDir: {}
```

2. Apply the Pod:
```bash
kubectl apply -f $HOME/ckad-simulation/22/cosmos-app-pod.yaml
```

3. Verify containers:
```bash
kubectl -n cosmos get pod cosmos-app
kubectl -n cosmos logs cosmos-app -c cosmos-init
kubectl -n cosmos logs cosmos-app -c cosmos-sidecar
kubectl -n cosmos exec cosmos-app -c cosmos-main -- ls -la /usr/share/nginx/html/shared/
```

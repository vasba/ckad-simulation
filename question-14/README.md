# Question 14 | Secret, Secret-Volume, Secret-Env

## Task
You need to make changes on an existing Pod in Namespace `moon` called `secret-handler`. Create a new Secret `secret1` which contains `user=test` and `pass=pwd`. The Secret's content should be available in Pod `secret-handler` as environment variables `SECRET1_USER` and `SECRET1_PASS`. The yaml for Pod `secret-handler` is available at `$HOME/ckad-simulation/14/secret-handler.yaml`.

There is existing yaml for another Secret at `$HOME/ckad-simulation/14/secret2.yaml`, create this Secret and mount it inside the same Pod at `/tmp/secret2`. Your changes should be saved under `$HOME/ckad-simulation/14/secret-handler-new.yaml`. Both Secrets should only be available in Namespace `moon`.

## Expected Answer

1. Create Secret `secret1`:
```bash
kubectl -n moon create secret generic secret1 --from-literal=user=test --from-literal=pass=pwd
```

2. Create Secret from existing yaml:
```bash
kubectl apply -f $HOME/ckad-simulation/14/secret2.yaml
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
kubectl get pod secret-handler -n moon -o yaml > $HOME/ckad-simulation/14/secret-handler-new.yaml
```
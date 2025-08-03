# Answer - Question 6 | ReadinessProbe

Create the Pod with readiness probe:
```bash
kubectl run pod6 --image=busybox:1.31.0 --dry-run=client -oyaml --command -- sh -c "touch /tmp/ready && sleep 1d" > 6.yaml
```

Edit the yaml to add the readiness probe:
```yaml
readinessProbe:
  exec:
    command:
    - sh
    - -c
    - cat /tmp/ready
  initialDelaySeconds: 5
  periodSeconds: 10
```

Then create and verify:
```bash
kubectl create -f 6.yaml
kubectl get pod pod6
```

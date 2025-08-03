# Question 6 | ReadinessProbe

## Task
Create a single Pod named `pod6` in Namespace `default` of image `busybox:1.31.0`. The Pod should have a readiness-probe executing `cat /tmp/ready`. It should initially wait 5 and periodically wait 10 seconds. This will set the container ready only if the file `/tmp/ready` exists.

The Pod should run the command `touch /tmp/ready && sleep 1d`, which will create the necessary file to be ready and then idles.

Create the Pod and confirm it starts.

## Expected Answer

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
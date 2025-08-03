# Question 16 | Logging sidecar

## Task
The Tech Lead of Mercury2D decided it's time for more logging, to finally fight all these missing data incidents. There is an existing container named `cleaner-con` in Deployment `cleaner` in Namespace `mercury`. This container mounts a volume and writes logs into a file called `cleaner.log`.

The yaml for the existing Deployment is available at `$HOME/ckad-simulation/16/cleaner.yaml`. Persist your changes at `$HOME/ckad-simulation/16/cleaner-new.yaml` but also make sure the Deployment is running.

Create a sidecar container named `logger-con`, image `busybox:1.31.0`, which mounts the same volume and writes the content of `cleaner.log` to stdout, you can use the `tail -f` command for this. This way it can be picked up by `kubectl logs`.

Check if the logs of the new container reveal something about the missing data incidents.

## Expected Answer

1. Check the existing deployment:
```bash
kubectl -n mercury get deployment cleaner
cat $HOME/ckad-simulation/16/cleaner.yaml
```

2. Edit the deployment to add the sidecar container:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: cleaner
  namespace: mercury
spec:
  replicas: 1
  selector:
    matchLabels:
      app: cleaner
  template:
    metadata:
      labels:
        app: cleaner
    spec:
      containers:
      - name: cleaner-con
        image: busybox:1.31.0
        command: ['sh', '-c', 'while true; do echo "$(date) - Cleaning data..." >> /var/log/cleaner.log; sleep 5; done']
        volumeMounts:
        - name: logs
          mountPath: /var/log
      - name: logger-con
        image: busybox:1.31.0
        command: ['sh', '-c', 'tail -f /var/log/cleaner.log']
        volumeMounts:
        - name: logs
          mountPath: /var/log
      volumes:
      - name: logs
        emptyDir: {}
```

3. Apply the changes:
```bash
kubectl apply -f $HOME/ckad-simulation/16/cleaner-new.yaml
```

4. Check the logs:
```bash
kubectl -n mercury logs cleaner-<pod-name> -c logger-con
```
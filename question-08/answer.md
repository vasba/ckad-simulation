# Answer - Question 8 | Deployment, Rollouts

1. Check the Deployment status:
```bash
kubectl -n neptune get deploy,pod | grep api-new-c32
```

2. Check the rollout history:
```bash
kubectl -n neptune rollout history deploy api-new-c32
```

3. Check Pod for errors:
```bash
kubectl -n neptune describe pod <failing-pod-name> | grep -i error
```

4. The error is usually an image name typo (e.g., `ngnix:1.16.3` instead of `nginx:1.16.3`)

5. Rollback to previous working version:
```bash
kubectl -n neptune rollout undo deploy api-new-c32
```

6. Verify the rollback worked:
```bash
kubectl -n neptune get deploy api-new-c32
```

The error was: **Image name typo - someone used 'ngnix:1.16.3' instead of 'nginx:1.16.3'**

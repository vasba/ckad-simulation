# Question 8 | Deployment, Rollouts

## Task
There is an existing Deployment named `api-new-c32` in Namespace `neptune`. A developer did make an update to the Deployment but the updated version never came online. Check the Deployment history and find a revision that works, then rollback to it. Could you tell Team Neptune what the error was so it doesn't happen again?

## Expected Answer

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
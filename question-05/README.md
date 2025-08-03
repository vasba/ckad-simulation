# Question 5 | ServiceAccount, Secret

## Task
Team Neptune has its own ServiceAccount named `neptune-sa-v2` in Namespace `neptune`. A coworker needs the token from the Secret that belongs to that ServiceAccount. Write the base64 decoded token to file `token`.

## Expected Answer

Find the secret associated with the ServiceAccount:
```bash
kubectl -n neptune get sa neptune-sa-v2
kubectl -n neptune get secrets
kubectl -n neptune get secrets -oyaml | grep annotations -A 1
```

Get the token from the secret:
```bash
kubectl -n neptune describe secret neptune-secret-1
```

The secret should have annotation `kubernetes.io/service-account.name: neptune-sa-v2`.

Extract and decode the token:
```bash
kubectl -n neptune get secret neptune-secret-1 -o jsonpath="{.data.token}" | base64 -d > token
```
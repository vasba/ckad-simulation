# Answer - Question 7 | Pods, Namespaces

1. Find the Pod with the e-commerce system:
```bash
kubectl -n saturn get pods --show-labels
kubectl -n saturn describe pods | grep -i "my-happy-shop"
```

2. Export the Pod YAML:
```bash
kubectl -n saturn get pod <pod-name> -o yaml > webserver.yaml
```

3. Edit the YAML file:
- Change namespace to `neptune`
- Remove status section
- Remove token volume and volumeMount if present
- Remove nodeName if present

4. Create the Pod in neptune namespace:
```bash
kubectl -n neptune create -f webserver.yaml
```

5. Delete the original Pod:
```bash
kubectl -n saturn delete pod <pod-name> --force --grace-period=0
```

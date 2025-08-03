# Question 7 | Pods, Namespaces

## Task
The board of Team Neptune decided to take over control of one e-commerce webserver from Team Saturn. The administrator who once setup this webserver is not part of the organisation any longer. All information you could get was that the e-commerce system is called `my-happy-shop`.

Search for the correct Pod in Namespace `saturn` and move it to Namespace `neptune`. It doesn't matter if you shut it down and spin it up again, it probably hasn't any customers anyways.

## Expected Answer

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
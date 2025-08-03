````markdown
# Question 17 | Network Policy

## Task
Team Sun needs to restrict network traffic to their Pod. Create a Pod named `frontend` of image `nginx:1.21.1-alpine` in Namespace `sun` with label `app: frontend`.

Create a NetworkPolicy named `frontend-deny` that denies all ingress and egress traffic for Pods with label `app: frontend` in Namespace `sun`.

Then create a second NetworkPolicy named `frontend-netpol` which allows:
- Ingress traffic from Pods with label `app: api` on port 80
- Egress traffic to Pods with label `app: api` on port 80

## Expected Answer

1. Create the Pod:
```bash
kubectl -n sun run frontend --image=nginx:1.21.1-alpine --labels=app=frontend
```

2. Create deny-all NetworkPolicy:
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: frontend-deny
  namespace: sun
spec:
  podSelector:
    matchLabels:
      app: frontend
  policyTypes:
  - Ingress
  - Egress
```

3. Create selective NetworkPolicy:
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: frontend-netpol
  namespace: sun
spec:
  podSelector:
    matchLabels:
      app: frontend
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          app: api
    ports:
    - protocol: TCP
      port: 80
  egress:
  - to:
    - podSelector:
        matchLabels:
          app: api
    ports:
    - protocol: TCP
      port: 80
```
````

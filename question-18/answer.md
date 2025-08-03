# Answer - Question 18 | Ingress

1. Create the Pods:
```bash
kubectl -n venus run venus-app --image=nginx:1.21.1-alpine --labels=app=venus-app
kubectl -n venus run venus-api --image=httpd:2.4.41-alpine --labels=app=venus-api
```

2. Create the Services:
```bash
kubectl -n venus expose pod venus-app --name=venus-app-svc --port=80
kubectl -n venus expose pod venus-api --name=venus-api-svc --port=8080 --target-port=80
```

3. Create the Ingress:
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: venus-ingress
  namespace: venus
spec:
  ingressClassName: nginx
  rules:
  - host: venus.example.com
    http:
      paths:
      - path: /app
        pathType: Prefix
        backend:
          service:
            name: venus-app-svc
            port:
              number: 80
      - path: /api
        pathType: Prefix
        backend:
          service:
            name: venus-api-svc
            port:
              number: 8080
```

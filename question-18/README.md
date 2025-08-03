````markdown
# Question 18 | Ingress

## Task
Team Venus needs external access to their applications. Create an Ingress named `venus-ingress` in Namespace `venus` with these requirements:

1. Use ingress class `nginx`
2. Route traffic for host `venus.example.com` path `/app` to service `venus-app-svc` on port 80
3. Route traffic for host `venus.example.com` path `/api` to service `venus-api-svc` on port 8080

Create the necessary Services and Pods to support this Ingress:
- Pod `venus-app` with image `nginx:1.21.1-alpine` and label `app: venus-app`
- Pod `venus-api` with image `httpd:2.4.41-alpine` and label `app: venus-api`
- Service `venus-app-svc` exposing the app pod on port 80
- Service `venus-api-svc` exposing the api pod on port 8080

## Expected Answer

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
````

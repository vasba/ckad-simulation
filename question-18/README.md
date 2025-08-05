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

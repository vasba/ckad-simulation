# Question 17 | Network Policy

## Task
Team Sun needs to restrict network traffic to their Pod. Create a Pod named `frontend` of image `nginx:1.21.1-alpine` in Namespace `sun` with label `app: frontend`.

Create a NetworkPolicy named `frontend-deny` that denies all ingress and egress traffic for Pods with label `app: frontend` in Namespace `sun`.

Then create a second NetworkPolicy named `frontend-netpol` which allows:
- Ingress traffic from Pods with label `app: api` on port 80
- Egress traffic to Pods with label `app: api` on port 80

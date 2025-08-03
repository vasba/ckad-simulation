# Answer - Question 15 | ConfigMap, Configmap-Volume

1. Check the current state:
```bash
kubectl -n moon get pods
kubectl -n moon describe pod <web-moon-pod-name>
```

2. Create the ConfigMap from file:
```bash
kubectl -n moon create configmap configmap-web-moon-html --from-file=index.html=/opt/course/15/web-moon.html
```

3. Verify the ConfigMap:
```bash
kubectl -n moon get configmap configmap-web-moon-html -o yaml
```

4. Wait for pods to restart or force restart:
```bash
kubectl -n moon rollout restart deployment web-moon
```

5. Test the nginx server:
```bash
kubectl -n moon get pods -o wide
kubectl run tmp --restart=Never --rm -i --image=nginx:alpine -- curl <pod-ip>
```

The ConfigMap will be mounted as a volume in the nginx pods, allowing them to serve the HTML content from `/opt/course/15/web-moon.html` as the default `index.html` page.

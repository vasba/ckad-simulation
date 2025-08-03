# Question 15 | ConfigMap, Configmap-Volume

## Task
Team Moonpie has a nginx server Deployment called `web-moon` in Namespace `moon`. Someone started configuring it but it was never completed. To complete please create a ConfigMap called `configmap-web-moon-html` containing the content of file `$HOME/ckad-simulation/15/web-moon.html` under the data key-name `index.html`.

The Deployment `web-moon` is already configured to work with this ConfigMap and serve its content. Test the nginx configuration for example using curl from a temporary `nginx:alpine` Pod.

## Expected Answer

1. Check the current state:
```bash
kubectl -n moon get pods
kubectl -n moon describe pod <web-moon-pod-name>
```

2. Create the ConfigMap from file:
```bash
kubectl -n moon create configmap configmap-web-moon-html --from-file=index.html=$HOME/ckad-simulation/15/web-moon.html
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

The ConfigMap will be mounted as a volume in the nginx pods, allowing them to serve the HTML content from `$HOME/ckad-simulation/15/web-moon.html` as the default `index.html` page.
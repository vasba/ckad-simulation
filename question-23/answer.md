# Answer - Question 23 | InitContainer

Based on Question 17 from the Killer Shell exam simulator.

## Steps to solve:

1. First, examine the existing deployment file:
```bash
cat $HOME/ckad-simulation/23/test-init-container.yaml
```

2. Copy and edit the deployment to add an InitContainer:
```bash
cp $HOME/ckad-simulation/23/test-init-container.yaml ~/23_test-init-container.yaml
vim ~/23_test-init-container.yaml
```

3. Add the InitContainer section to the spec.template.spec (before the containers section):

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: test-init-container
  namespace: mars
spec:
  replicas: 1
  selector:
    matchLabels:
      id: test-init-container
  template:
    metadata:
      labels:
        id: test-init-container
    spec:
      volumes:
      - name: web-content
        emptyDir: {}
      initContainers:
      # initContainer start
      - name: init-con
        image: busybox:1.31.0
        command: ['sh', '-c', 'echo "check this out!" > /tmp/web-content/index.html']
        volumeMounts:
        - name: web-content
          mountPath: /tmp/web-content
      # initContainer end
      containers:
      - image: nginx:1.17.3-alpine
        name: nginx
        volumeMounts:
        - name: web-content
          mountPath: /usr/share/nginx/html
        ports:
        - containerPort: 80
```

4. Create/apply the deployment:
```bash
kubectl apply -f ~/23_test-init-container.yaml
```

5. Test the implementation:
```bash
# Get the pod IP
kubectl -n mars get pod -o wide

# Test with temporary nginx pod and curl
kubectl run tmp --restart=Never --rm -i --image=nginx:alpine -- curl [POD_IP]
```

## Expected result:
The curl command should return "check this out!" as the content.

## Key points:
- The InitContainer runs before the main nginx container
- It mounts the same `web-content` volume but to `/tmp/web-content` path  
- It creates the `index.html` file with the required content using the `echo` command
- The nginx container mounts the same volume to `/usr/share/nginx/html` where nginx serves files
- InitContainers must complete successfully before main containers start
- The deployment is in the `mars` namespace
- Labels use `id: test-init-container` (not `app:`) as shown in the original question

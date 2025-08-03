# Question 10 | Service, Logs

## Task
Team Pluto needs a new cluster internal Service. Create a ClusterIP Service named `project-plt-6cc-svc` in Namespace `pluto`. This Service should expose a single Pod named `project-plt-6cc-api` of image `nginx:1.17.3-alpine`, create that Pod as well. The Pod should be identified by label `project: plt-6cc-api`. The Service should use tcp port redirection of `3333:80`.

Finally use for example curl from a temporary `nginx:alpine` Pod to get the response from the Service. Write the response into `/opt/course/10/service_test.html`. Also check if the logs of Pod `project-plt-6cc-api` show the request and write those into `service_test.log`.

## Expected Answer

1. Create the Pod:
```bash
kubectl -n pluto run project-plt-6cc-api --image=nginx:1.17.3-alpine --labels project=plt-6cc-api
```

2. Create the Service:
```bash
kubectl -n pluto expose pod project-plt-6cc-api --name project-plt-6cc-svc --port 3333 --target-port 80
```

3. Test the Service:
```bash
kubectl run tmp --restart=Never --rm -i --image=nginx:alpine -- curl http://project-plt-6cc-svc.pluto:3333
```

4. Save the response:
```bash
kubectl run tmp --restart=Never --rm -i --image=nginx:alpine -- curl http://project-plt-6cc-svc.pluto:3333 > /opt/course/10/service_test.html
```

5. Get the logs:
```bash
kubectl -n pluto logs project-plt-6cc-api > service_test.log
```
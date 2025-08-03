# Answer - Question 10 | Service, Logs

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
kubectl run tmp --restart=Never --rm -i --image=nginx:alpine -- curl http://project-plt-6cc-svc.pluto:3333 > $HOME/ckad-simulation/10/service_test.html
```

5. Get the logs:
```bash
kubectl -n pluto logs project-plt-6cc-api > service_test.log
```

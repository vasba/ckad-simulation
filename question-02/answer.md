# Answer - Question 2 | Pods

Create the pod:
```bash
kubectl run pod1 --image=httpd:2.4.41-alpine --dry-run=client -oyaml > 2.yaml
```

Edit the container name in the YAML file and apply:
```bash
kubectl create -f 2.yaml
```

Create the status command:
```bash
# pod1-status-command.sh
kubectl -n default describe pod pod1 | grep -i status:
```

Alternative using jsonpath:
```bash
kubectl -n default get pod pod1 -o jsonpath="{.status.phase}"
```

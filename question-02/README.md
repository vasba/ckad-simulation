# Question 2 | Pods

## Task
Create a single Pod of image `httpd:2.4.41-alpine` in Namespace `default`. The Pod should be named `pod1` and the container should be named `pod1-container`.

Your manager would like to run a command manually on occasion to output the status of that exact Pod. Please write a command that does this into `pod1-status-command.sh` on ckad5601. The command should use kubectl.

## Expected Answer

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
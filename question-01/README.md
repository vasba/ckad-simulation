# Question 1 | Namespaces

## Task
The DevOps team would like to get the list of all Namespaces in the cluster.
The list can contain other columns like STATUS or AGE.
Save the list to `namespaces`.

## Expected Answer
```bash
kubectl get ns > namespaces
```

The content should look like:
```
NAME               STATUS   AGE
default            Active   136m
earth              Active   105m
jupiter            Active   105m
kube-node-lease    Active   136m
kube-public        Active   136m
kube-system        Active   136m
mars               Active   105m
shell-intern       Active   105m
```
# Answer - Question 25 | Service ClusterIP->NodePort

Based on Question 19 from the Killer Shell exam simulator.

## Problem
In Namespace jupiter there's an apache Deployment named `jupiter-crew-deploy` and a ClusterIP Service called `jupiter-crew-svc`. Change this service to a NodePort to make it available on all nodes on port 30100.

## Steps to solve:

1. **Get an overview of existing resources**:
```bash
kubectl -n jupiter get all
```

2. **Test the existing ClusterIP Service** (optional but good practice):
```bash
kubectl run tmp --restart=Never --rm -i --image=nginx:alpine -n jupiter -- curl -m 5 jupiter-crew-svc:8080
```
This should return the Apache "It works!" page.

3. **Edit the service to change type and add nodePort**:
```bash
kubectl -n jupiter edit service jupiter-crew-svc
```

Make the following changes:
```yaml
apiVersion: v1
kind: Service
metadata:
  name: jupiter-crew-svc
  namespace: jupiter
spec:
  ports:
  - name: "8080-80"
    port: 8080
    protocol: TCP
    targetPort: 80
    nodePort: 30100     # ADD this line
  selector:
    id: jupiter-crew
  type: NodePort        # CHANGE from ClusterIP to NodePort
```

4. **Verify the service type was updated**:
```bash
kubectl -n jupiter get svc
```
Should show `NodePort` type and port `8080:30100/TCP`.

5. **Test internal connectivity still works** (optional):
```bash
kubectl run tmp --restart=Never --rm -i --image=nginx:alpine -n jupiter -- curl -m 5 jupiter-crew-svc:8080
```

6. **Get node internal IPs**:
```bash
kubectl get nodes -o wide
```
Note the INTERNAL-IP column values.

7. **Test NodePort connectivity from external/node level**:
```bash
curl [NODE_IP]:30100
```
Replace `[NODE_IP]` with actual node IP. Should return the Apache "It works!" page.

8. **Check which node the pod is running on**:
```bash
kubectl -n jupiter get pods -o wide
```
Note the NODE column.

## Expected Results:

- **Service reachable on ALL nodes**: Even if the pod runs on only one specific node, the NodePort service makes it available on port 30100 of ALL nodes in the cluster
- **Internal access still works**: The ClusterIP functionality is preserved, so internal cluster access via `jupiter-crew-svc:8080` still works
- **External access works**: The service is now accessible from outside the cluster via `[ANY_NODE_IP]:30100`

## Key Learning Points:

- **NodePort lies on top of ClusterIP**: When you create a NodePort service, it creates a ClusterIP service internally and exposes it on all nodes
- **Available on all nodes**: The service is accessible on the specified port on ALL nodes, regardless of which node the pod runs on
- **Port ranges**: NodePorts must be in the range 30000-32767 by default
- **Both internal and external access**: NodePort services maintain ClusterIP functionality while adding external accessibility

## Service Types Comparison:
- **ClusterIP**: Only accessible within the cluster
- **NodePort**: Accessible within cluster + externally on all node IPs
- **LoadBalancer**: NodePort + cloud load balancer (if supported)
- **ExternalName**: Maps to external DNS name

# Answer - Question 12 | Storage, PV, PVC, Pod volume

1. Create the PersistentVolume:
```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: earth-project-earthflower-pv
spec:
  capacity:
    storage: 2Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: "/Volumes/Data"
```

2. Create the PersistentVolumeClaim:
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: earth-project-earthflower-pvc
  namespace: earth
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 2Gi
```

3. Create the Deployment with volume mount:
```bash
kubectl -n earth create deployment project-earthflower --image=httpd:2.4.41-alpine --dry-run=client -oyaml > deployment.yaml
# Edit to add volume and volumeMount
```

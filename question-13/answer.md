# Answer - Question 13 | Storage, StorageClass, PVC

1. Create the StorageClass:
```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: moon-retain
provisioner: moon-retainer
reclaimPolicy: Retain
```

2. Create the PersistentVolumeClaim:
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: moon-pvc-126
  namespace: moon
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 3Gi
  storageClassName: moon-retain
```

3. Check the PVC status:
```bash
kubectl -n moon describe pvc moon-pvc-126
```

4. Write the event message:
```bash
kubectl -n moon describe pvc moon-pvc-126 | grep -A 10 Events: > /opt/course/13/pvc-126-reason
```

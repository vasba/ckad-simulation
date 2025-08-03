# Question 13 | Storage, StorageClass, PVC

## Task
Team Moonpie, which has the Namespace `moon`, needs more storage. Create a new PersistentVolumeClaim named `moon-pvc-126` in that namespace. This claim should use a new StorageClass `moon-retain` with the provisioner set to `moon-retainer` and the reclaimPolicy set to `Retain`. The claim should request storage of `3Gi`, an accessMode of `ReadWriteOnce` and should use the new StorageClass.

The provisioner `moon-retainer` will be created by another team, so it's expected that the PVC will not boot yet. Confirm this by writing the event message from the PVC into file `/opt/course/13/pvc-126-reason`.

## Expected Answer

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
# Question 12 | Storage, PV, PVC, Pod volume

## Task
Create a new PersistentVolume named `earth-project-earthflower-pv`. It should have a capacity of `2Gi`, accessMode `ReadWriteOnce`, hostPath `/Volumes/Data` and no storageClassName defined.

Next create a new PersistentVolumeClaim in Namespace `earth` named `earth-project-earthflower-pvc`. It should request `2Gi` storage, accessMode `ReadWriteOnce` and should not define a storageClassName. The PVC should bound to the PV correctly.

Finally create a new Deployment `project-earthflower` in Namespace `earth` which mounts that volume at `/tmp/project-data`. The Pods of that Deployment should be of image `httpd:2.4.41-alpine`.

## Expected Answer

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
# Answer - Question 20 | CronJob

1. Create the CronJob:
```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: jupiter-backup
  namespace: jupiter
spec:
  schedule: "30 2 * * *"
  successfulJobsHistoryLimit: 3
  failedJobsHistoryLimit: 1
  jobTemplate:
    spec:
      activeDeadlineSeconds: 60
      template:
        spec:
          containers:
          - name: backup
            image: busybox:1.31.0
            command:
            - sh
            - -c
            - "echo 'Backup started at $(date)' && sleep 10 && echo 'Backup completed at $(date)'"
          restartPolicy: Never
```

2. Apply the CronJob:
```bash
kubectl apply -f jupiter-backup-cronjob.yaml
```

3. Test by manually triggering:
```bash
kubectl -n jupiter create job --from=cronjob/jupiter-backup jupiter-backup-manual
```

4. Check the logs:
```bash
kubectl -n jupiter logs job/jupiter-backup-manual
```

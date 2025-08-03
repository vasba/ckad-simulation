# Answer - Question 3 | Job

Generate base Job yaml:
```bash
kubectl -n neptune create job neb-new-job --image=busybox:1.31.0 --dry-run=client -oyaml -- sh -c "sleep 2 && echo done" > job.yaml
```

Edit the yaml to add required fields:
- `completions: 3`
- `parallelism: 2`
- `labels: id: awesome-job`
- Update container name to `neb-new-job-container`

Then create the job:
```bash
kubectl -f job.yaml create
```

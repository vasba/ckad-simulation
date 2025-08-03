# Question 3 | Job

## Task
Team Neptune needs a Job template located at `job.yaml`. This Job should run image `busybox:1.31.0` and execute `sleep 2 && echo done`. It should be in namespace `neptune`, run a total of 3 times and should execute 2 runs in parallel.

Start the Job and check its history. Each pod created by the Job should have the label `id: awesome-job`. The job should be named `neb-new-job` and the container `neb-new-job-container`.

## Expected Answer

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
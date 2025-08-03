# Question 4 | Helm Management

## Task
Team Mercury asked you to perform some operations using Helm, all in Namespace `mercury`:

1. Delete release `internal-issue-report-apiv1`
2. Upgrade release `internal-issue-report-apiv2` to any newer version of chart `bitnami/nginx` available
3. Install a new release `internal-issue-report-apache` of chart `bitnami/apache`. The Deployment should have two replicas, set these via Helm-values during install
4. There seems to be a broken release, stuck in pending-install state. Find it and delete it

## Expected Answer

1. Delete release:
```bash
helm -n mercury uninstall internal-issue-report-apiv1
```

2. Upgrade release:
```bash
helm repo update
helm -n mercury upgrade internal-issue-report-apiv2 bitnami/nginx
```

3. Install new release:
```bash
helm -n mercury install internal-issue-report-apache bitnami/apache --set replicaCount=2
```

4. Find and delete broken release:
```bash
helm -n mercury ls -a
helm -n mercury uninstall internal-issue-report-daniel
```
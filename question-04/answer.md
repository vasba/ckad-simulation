# Answer - Question 4 | Helm Management

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

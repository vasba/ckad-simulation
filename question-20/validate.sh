#!/bin/bash

# Validation script for Question 20 - CronJob
echo "=== Validating Question 20: CronJob ==="

# Check if jupiter-backup CronJob exists in jupiter namespace
if kubectl get cronjob jupiter-backup -n jupiter &>/dev/null; then
    echo "✅ PASS: jupiter-backup CronJob exists in jupiter namespace"
else
    echo "❌ FAIL: jupiter-backup CronJob not found in jupiter namespace"
    exit 1
fi

# Check CronJob schedule (should be "30 2 * * *" for 2:30 AM daily)
schedule=$(kubectl get cronjob jupiter-backup -n jupiter -o jsonpath='{.spec.schedule}')
if [[ "$schedule" == "30 2 * * *" ]]; then
    echo "✅ PASS: CronJob has correct schedule (30 2 * * * - 2:30 AM daily)"
else
    echo "❌ FAIL: CronJob has wrong schedule ($schedule), expected '30 2 * * *'"
    exit 1
fi

# Check successfulJobsHistoryLimit
successful_limit=$(kubectl get cronjob jupiter-backup -n jupiter -o jsonpath='{.spec.successfulJobsHistoryLimit}')
if [[ "$successful_limit" == "3" ]]; then
    echo "✅ PASS: CronJob has correct successfulJobsHistoryLimit (3)"
else
    echo "❌ FAIL: CronJob has wrong successfulJobsHistoryLimit ($successful_limit), expected 3"
    exit 1
fi

# Check failedJobsHistoryLimit
failed_limit=$(kubectl get cronjob jupiter-backup -n jupiter -o jsonpath='{.spec.failedJobsHistoryLimit}')
if [[ "$failed_limit" == "1" ]]; then
    echo "✅ PASS: CronJob has correct failedJobsHistoryLimit (1)"
else
    echo "❌ FAIL: CronJob has wrong failedJobsHistoryLimit ($failed_limit), expected 1"
    exit 1
fi

# Check activeDeadlineSeconds
deadline=$(kubectl get cronjob jupiter-backup -n jupiter -o jsonpath='{.spec.jobTemplate.spec.activeDeadlineSeconds}')
if [[ "$deadline" == "60" ]]; then
    echo "✅ PASS: CronJob has correct activeDeadlineSeconds (60)"
else
    echo "❌ FAIL: CronJob has wrong activeDeadlineSeconds ($deadline), expected 60"
    exit 1
fi

# Check container image
image=$(kubectl get cronjob jupiter-backup -n jupiter -o jsonpath='{.spec.jobTemplate.spec.template.spec.containers[0].image}')
if [[ "$image" == "busybox:1.31.0" ]]; then
    echo "✅ PASS: CronJob is using correct image (busybox:1.31.0)"
else
    echo "❌ FAIL: CronJob is using wrong image ($image), expected busybox:1.31.0"
    exit 1
fi

# Check container name
container_name=$(kubectl get cronjob jupiter-backup -n jupiter -o jsonpath='{.spec.jobTemplate.spec.template.spec.containers[0].name}')
if [[ "$container_name" == "backup" ]]; then
    echo "✅ PASS: Container name is correct (backup)"
else
    echo "❌ FAIL: Container name is wrong ($container_name), expected backup"
    exit 1
fi

# Check restartPolicy
restart_policy=$(kubectl get cronjob jupiter-backup -n jupiter -o jsonpath='{.spec.jobTemplate.spec.template.spec.restartPolicy}')
if [[ "$restart_policy" == "Never" ]]; then
    echo "✅ PASS: RestartPolicy is correct (Never)"
else
    echo "❌ FAIL: RestartPolicy is wrong ($restart_policy), expected Never"
    exit 1
fi

# Check if command includes backup messaging
command=$(kubectl get cronjob jupiter-backup -n jupiter -o jsonpath='{.spec.jobTemplate.spec.template.spec.containers[0].command[*]}')
if [[ "$command" == *"Backup"* ]] && [[ "$command" == *"started"* ]] && [[ "$command" == *"completed"* ]]; then
    echo "✅ PASS: Command includes backup messaging"
else
    echo "❌ FAIL: Command does not include expected backup messaging"
    exit 1
fi

# Check if any jobs have been created (optional, depends on timing)
job_count=$(kubectl get jobs -n jupiter -l job-name=jupiter-backup --no-headers 2>/dev/null | wc -l)
if [[ "$job_count" -gt 0 ]]; then
    echo "✅ PASS: CronJob has created $job_count job(s)"
else
    echo "ℹ️  INFO: No jobs created yet (depends on schedule timing)"
fi

echo "🎉 All validations passed for Question 20!"

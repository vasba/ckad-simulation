# Question 20 | CronJob

## Task
Team Jupiter needs a scheduled backup job. Create a CronJob named `jupiter-backup` in Namespace `jupiter` with these requirements:

1. Schedule: Run every day at 2:30 AM (use cron expression `30 2 * * *`)
2. Use image `busybox:1.31.0`
3. Command: `sh -c "echo 'Backup started at $(date)' && sleep 10 && echo 'Backup completed at $(date)'"`
4. Set `successfulJobsHistoryLimit` to 3
5. Set `failedJobsHistoryLimit` to 1
6. Job should complete within 60 seconds (set `activeDeadlineSeconds`)
7. Job should not restart on failure (`restartPolicy: Never`)

Create the CronJob and trigger it manually to test.


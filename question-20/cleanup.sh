#!/bin/bash

# Question 20 - CronJob Cleanup
# Removes all resources created for this exercise

echo "Cleaning up Question 20 - CronJob exercise..."

# Delete the CronJob (this will also clean up associated jobs)
kubectl -n jupiter delete cronjob jupiter-backup --ignore-not-found=true

# Delete any manually created jobs
kubectl -n jupiter delete job jupiter-backup-manual --ignore-not-found=true

# Clean up the course directory
rm -rf $HOME/ckad-simulation/20

echo "Cleanup complete for Question 20"

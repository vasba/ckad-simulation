#!/bin/bash

# CKAD Simulation - Master Setup Script
# Sets up all exercises for CKAD certification practice

echo "=========================================="
echo "CKAD Simulation - Setting up all exercises"
echo "=========================================="

# Function to run setup for a question if it exists
setup_question() {
    local question_num=$1
    local question_dir="question-$(printf "%02d" $question_num)"
    
    if [ -d "$question_dir" ] && [ -f "$question_dir/setup.sh" ]; then
        echo ""
        echo "Setting up Question $question_num..."
        cd "$question_dir"
        ./setup.sh
        cd ..
    else
        echo "Question $question_num not implemented yet"
    fi
}

# Setup questions 1-22
for i in {1..22}; do
    setup_question $i
done

echo ""
echo "=========================================="
echo "Setup complete!"
echo "=========================================="
echo ""
echo "Available exercises:"
echo "- Question 1: Namespaces"
echo "- Question 2: Pods"
echo "- Question 3: Job"
echo "- Question 4: Helm Management"
echo "- Question 5: ServiceAccount, Secret"
echo "- Question 6: ReadinessProbe"
echo "- Question 7: Pods, Namespaces"
echo "- Question 8: Deployment, Rollouts"
echo "- Question 9: Pod -> Deployment"
echo "- Question 10: Service, Logs"
echo "- Question 11: Working with Containers"
echo "- Question 12: Storage, PV, PVC, Pod volume"
echo "- Question 13: Storage, StorageClass, PVC"
echo "- Question 14: Secret, Secret-Volume, Secret-Env"
echo "- Question 15: ConfigMap, Configmap-Volume"
echo "- Question 16: Logging sidecar"
echo "- Question 17: Network Policy"
echo "- Question 18: Ingress"
echo "- Question 19: Resource Requirements, Limits, Requests"
echo "- Question 20: CronJob"
echo "- Question 21: SecurityContext, PodSecurityContext"
echo "- Question 22: Multi-container Pod (Sidecar, Init Container)"
echo ""
echo "Each exercise folder contains:"
echo "- README.md: Exercise description and expected answers"
echo "- setup.sh: Sets up the exercise environment"
echo "- cleanup.sh: Cleans up after the exercise"
echo "- Additional YAML files as needed"
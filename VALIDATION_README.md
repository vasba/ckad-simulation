# CKAD Simulation Validation Scripts

This repository contains validation scripts for each question in the CKAD (Certified Kubernetes Application Developer) simulation. Each validation script verifies that the solution has been implemented correctly according to the requirements specified in the `answer.md` files.

## Structure

```
ckad-simulation/
├── validate-all.sh           # Master validation script
├── question-01/
│   ├── validate.sh          # Validation script for question 1
│   ├── answer.md            # Solution guide
│   └── ...
├── question-02/
│   ├── validate.sh          # Validation script for question 2
│   ├── answer.md            # Solution guide
│   └── ...
└── ...
```

## Usage

### Running All Validations

To run validation for all 22 questions:

```bash
./validate-all.sh
```

or

```bash
./validate-all.sh all
```

### Running Individual Validations

To validate a specific question (e.g., question 5):

```bash
./validate-all.sh 5
```

or navigate to the specific question directory:

```bash
cd question-05/
./validate.sh
```

### Getting Help

```bash
./validate-all.sh help
```

## What Each Validation Script Checks

Each validation script performs comprehensive checks based on the requirements in the corresponding `answer.md` file:

### Question 1 - Namespaces
- ✅ Checks if `namespaces` file exists
- ✅ Validates file contains required namespaces
- ✅ Verifies proper format with headers

### Question 2 - Pods
- ✅ Verifies pod1 exists with correct image
- ✅ Checks container name
- ✅ Validates status command script exists and works

### Question 3 - Job
- ✅ Confirms job exists with correct specifications
- ✅ Validates completions, parallelism, and labels
- ✅ Checks container name and image

### Question 4 - Helm Management
- ✅ Verifies Helm releases are properly managed
- ✅ Checks installation, upgrade, and deletion operations

### Question 5 - ServiceAccount, Secret
- ✅ Validates ServiceAccount and Secret existence
- ✅ Checks secret annotations and token extraction

### Question 6 - ReadinessProbe
- ✅ Confirms pod has readiness probe configured correctly
- ✅ Validates probe command and timing parameters

### Question 7 - Pods, Namespaces
- ✅ Verifies pod migration between namespaces
- ✅ Checks YAML file cleanup (status, nodeName removal)

### Question 8 - Deployment, Rollouts
- ✅ Validates deployment rollback operations
- ✅ Checks for correct image and successful deployment

### Question 9 - Pod -> Deployment
- ✅ Confirms conversion from Pod to Deployment
- ✅ Validates security context and replica count

### Question 10 - Service, Logs
- ✅ Checks pod, service, and connectivity
- ✅ Validates service test files and logs

### Question 11 - Working with Containers
- ✅ Verifies Dockerfile modifications
- ✅ Checks container builds and logs

### Question 12 - Storage, PV, PVC, Pod volume
- ✅ Validates PersistentVolume and PersistentVolumeClaim
- ✅ Checks volume mounting in pods

### Question 13 - Storage, StorageClass, PVC
- ✅ Confirms StorageClass creation with correct provisioner
- ✅ Validates PVC using the StorageClass

### Question 14 - Secret, Secret-Volume, Secret-Env
- ✅ Checks secret creation and usage
- ✅ Validates environment variables and volume mounts

### Question 15 - ConfigMap, Configmap-Volume
- ✅ Verifies ConfigMap creation from file
- ✅ Checks deployment and volume mounting

### Question 16 - Logging sidecar
- ✅ Validates multi-container pod with sidecar pattern
- ✅ Checks shared volumes and container specifications

### Question 17 - Network Policy
- ✅ Confirms pod creation with network policies
- ✅ Validates both deny-all and selective policies

### Question 18 - Ingress
- ✅ Checks pod and service creation
- ✅ Validates Ingress configuration with correct paths

### Question 19 - Resource Requirements, Limits, Requests
- ✅ Verifies deployment with resource constraints
- ✅ Checks liveness and readiness probes

### Question 20 - CronJob
- ✅ Validates CronJob schedule and configuration
- ✅ Checks job template and history limits

### Question 21 - SecurityContext, PodSecurityContext
- ✅ Confirms pod and container security contexts
- ✅ Validates capabilities and security settings

### Question 22 - Multi-container Pod (Sidecar, Init Container)
- ✅ Checks init container and multi-container setup
- ✅ Validates shared volumes and container interactions

## Output Format

The validation scripts provide clear, color-coded output:

- ✅ **Green**: Validation passed
- ❌ **Red**: Validation failed
- ⚠️ **Yellow**: Warning or informational message
- 🎉 **Celebration**: All validations passed

## Requirements

- Kubernetes cluster access with `kubectl` configured
- Bash shell
- Required namespaces and permissions for the specific questions

## Notes

- Some validations may show warnings if certain resources are not yet ready or if optional components are missing
- The scripts assume you have followed the setup instructions for each question
- Network connectivity may be required for some validations (e.g., testing services)

## Troubleshooting

If a validation fails:

1. Review the specific error message
2. Check the corresponding `answer.md` file for the correct solution
3. Verify your Kubernetes cluster state
4. Ensure all required namespaces exist
5. Check that you have the necessary permissions

For questions about container images or external registries, ensure your cluster has access to pull the required images.

# CKAD Simulation Environment

This repository provides a comprehensive practice environment for the **Certified Kubernetes Application Developer (CKAD)** exam. It contains 22 hands-on exercises that simulate real CKAD exam scenarios, helping you prepare for the certification.

## 📋 What's Included

- **22 Practice Questions**: Each question mirrors the style and complexity of actual CKAD exam questions
- **Automated Setup Scripts**: Quick environment setup for each exercise
- **Cleanup Scripts**: Easy teardown of resources after practice
- **Sample Solutions**: Reference answers to validate your approach
- **Kubernetes Manifests**: Pre-configured YAML files for exercise setup

## 🚀 Getting Started

### Prerequisites

- **Linux environment** (this repository is designed for Linux)
  - **Linux users**: Native support
  - **Windows users**: Install [WSL (Windows Subsystem for Linux)](https://docs.microsoft.com/en-us/windows/wsl/install) for the best experience
  - **macOS users**: Should work natively with bash
- A Kubernetes cluster (local or cloud-based)
  - **For local development**: Install [Minikube](https://minikube.sigs.k8s.io/docs/start/) for a lightweight local Kubernetes cluster
  - **Alternative local options**: Docker Desktop with Kubernetes, kind, or k3s
  - **Cloud options**: EKS, GKE, AKS, or any managed Kubernetes service
- `kubectl` configured and connected to your cluster
- Basic understanding of Kubernetes concepts

#### Setting up Minikube (Recommended for local practice)

```bash
# Install Minikube (example for Linux)
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube

# Start your local cluster
minikube start

# Verify cluster is running
kubectl cluster-info
```

### Quick Start

1. **Clone the repository**:
   ```bash
   git clone <repository-url>
   cd ckad-simulation
   ```

2. **Set up all exercises at once**:
   ```bash
   chmod +x setup-all.sh
   ./setup-all.sh
   ```

3. **Or set up individual exercises**:
   ```bash
   cd question-01
   chmod +x setup.sh
   ./setup.sh
   ```

## 📂 Repository Structure

```
ckad-simulation/
├── question-XX/           # Individual exercise folders (01-22)
│   ├── README.md         # Exercise description and tasks
│   ├── setup.sh          # Sets up the exercise environment
│   ├── cleanup.sh        # Cleans up all resources
│   ├── answer.md         # Sample solution
│   └── *.yaml           # Kubernetes manifests (when needed)
├── setup-all.sh          # Sets up all exercises
├── cleanup-all.sh        # Cleans up all exercises
└── specifications.md     # Development specifications
```

## 🎯 How to Use

### For Individual Practice

1. **Navigate to a question folder**:
   ```bash
   cd question-XX
   ```

2. **Read the exercise description**:
   ```bash
   cat README.md
   ```

3. **Set up the exercise environment**:
   ```bash
   ./setup.sh
   ```

4. **Solve the exercise** using kubectl and YAML manifests

5. **Check the sample solution** (optional):
   ```bash
   cat answer.md
   ```

6. **Clean up when done**:
   ```bash
   ./cleanup.sh
   ```

### For Full Practice Sessions

1. **Set up all exercises**:
   ```bash
   ./setup-all.sh
   ```

2. **Practice questions in sequence or random order**

3. **Clean up everything when finished**:
   ```bash
   ./cleanup-all.sh
   ```

## 📚 Exercise Topics Covered

The exercises cover all major CKAD exam domains:

- **Application Design and Build** (20%)
  - Container images and Dockerfiles
  - Jobs and CronJobs
  - Multi-container Pod design patterns

- **Application Deployment** (20%)
  - Deployments and rolling updates
  - Blue/green and canary deployments
  - Helm charts

- **Application Observability and Maintenance** (15%)
  - Logging and monitoring
  - Debugging and troubleshooting
  - Health checks (probes)

- **Application Environment, Configuration and Security** (25%)
  - ConfigMaps and Secrets
  - SecurityContexts
  - Service Accounts and RBAC

- **Services and Networking** (20%)
  - Services (ClusterIP, NodePort, LoadBalancer)
  - Ingress controllers
  - NetworkPolicies

## 💡 Study Tips

1. **Time yourself**: CKAD is a time-constrained exam (2 hours)
2. **Practice kubectl shortcuts**: Master imperative commands
3. **Understand YAML structure**: Be comfortable editing manifests
4. **Use kubectl explain**: Learn to use built-in documentation
5. **Practice troubleshooting**: Debug failing pods and services

## 🧹 Cleanup

Always clean up resources after practice to avoid cluttering your cluster:

```bash
# Clean up individual exercise
cd question-XX && ./cleanup.sh

# Clean up all exercises
./cleanup-all.sh
```

## 🤝 Contributing

Feel free to:
- Report issues with exercises
- Suggest improvements
- Add new practice questions
- Fix typos or errors

## 📄 License

This project is for educational purposes. Please refer to the official CKAD documentation for the most up-to-date exam information.

---

**Good luck with your CKAD certification! 🎉**
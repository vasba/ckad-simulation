# Question 22 | Multi-container Pod (Sidecar, Init Container)

## Task
Team Cosmos needs a complex pod setup with multiple containers. Create a Pod named `cosmos-app` in Namespace `cosmos` with the following specifications:

1. **Init Container** named `cosmos-init`:
   - Image: `busybox:1.31.0`
   - Command: `sh -c "echo 'Initializing...' && sleep 5 && echo 'Init complete' > /shared/init-status"`
   - Mount an emptyDir volume at `/shared`

2. **Main Container** named `cosmos-main`:
   - Image: `nginx:1.21.1-alpine`
   - Mount the same emptyDir volume at `/usr/share/nginx/html/shared`
   - Environment variable: `APP_NAME=cosmos-application`

3. **Sidecar Container** named `cosmos-sidecar`:
   - Image: `busybox:1.31.0`
   - Command: `sh -c "while true; do echo \"$(date): Sidecar monitoring...\" >> /shared/sidecar.log; sleep 30; done"`
   - Mount the same emptyDir volume at `/shared`

4. Add labels: `app: cosmos-app`, `tier: frontend`

Save the Pod specification as `$HOME/ckad-simulation/22/cosmos-app-pod.yaml` and verify all containers start successfully.


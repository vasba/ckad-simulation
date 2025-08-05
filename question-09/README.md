# Question 9 | Pod -> Deployment

## Task
In Namespace `pluto` there is single Pod named `holy-api`. It has been working okay for a while now but Team Pluto needs it to be more reliable.

Convert the Pod into a Deployment named `holy-api` with 3 replicas and delete the single Pod once done. The raw Pod template file is available at `holy-api-pod.yaml`.

In addition, the new Deployment should set `allowPrivilegeEscalation: false` and `privileged: false` for the security context on container level.

Please create the Deployment and save its yaml under `holy-api-deployment.yaml`.


# Question 28 | Liveness Probe

In Namespace pluto there is a Deployment named project-23-api. It has been working okay for a while but Team Pluto needs it to
be more reliable. Implement a liveness-probe which checks the container to be reachable on port 80. Initially the probe should wait
10, periodically 15 seconds.

The original Deployment yaml is available at $HOME/ckad-simulation/28/project-23-api.yaml. Save your changes at $HOME/ckad-simulation/28/project-
23-api-new.yaml and apply the changes.

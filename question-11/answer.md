# Answer - Question 11 | Working with Containers

This exercise uses a Python application that generates random numbers and logs them with timestamps.

1. Modify the Dockerfile:
```bash
# Change ENV SUN_CIPHER_ID=<value> to:
ENV SUN_CIPHER_ID=5b9c1065-e39d-4a43-a04a-e59bcea3e03f
```

2. Build with Docker:
```bash
sudo docker build -t registry.killer.sh:5000/sun-cipher:v1-docker .
sudo docker push registry.killer.sh:5000/sun-cipher:v1-docker
```

3. Build with Podman:
```bash
sudo podman build -t registry.killer.sh:5000/sun-cipher:v1-podman .
sudo podman push registry.killer.sh:5000/sun-cipher:v1-podman
```

4. Run container:
```bash
# Primary method (if networking works):
sudo podman run -d --name sun-cipher registry.killer.sh:5000/sun-cipher:v1-podman

# Alternative method if CNI network issues occur:
sudo podman run -d --name sun-cipher --network=host registry.killer.sh:5000/sun-cipher:v1-podman

# Or use Docker if Podman networking fails:
sudo docker run -d --name sun-cipher registry.killer.sh:5000/sun-cipher:v1-podman
```

Note: If you encounter CNI network errors with Podman, use the `--network=host` flag or switch to Docker for running the container.

5. Get logs:
```bash
# Get logs from the container and save to file:
sudo podman logs sun-cipher > $HOME/ckad-simulation/11/logs

# If using Docker instead:
# sudo docker logs sun-cipher > $HOME/ckad-simulation/11/logs
```

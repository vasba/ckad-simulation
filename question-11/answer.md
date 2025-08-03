# Answer - Question 11 | Working with Containers

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
sudo podman run -d --name sun-cipher registry.killer.sh:5000/sun-cipher:v1-podman
```

5. Get logs:
```bash
sudo podman logs sun-cipher > $HOME/ckad-simulation/11/logs
```

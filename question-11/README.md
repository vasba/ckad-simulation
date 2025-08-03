# Question 11 | Working with Containers

## Task
There are files to build a container image located at `$HOME/ckad-simulation/11/image`. The container will run a Golang application which outputs information to stdout. You're asked to perform the following tasks:

ℹ️ Run all Docker and Podman commands as user root. Use `sudo docker` and `sudo podman` or become root with `sudo -i`

1. Change the Dockerfile: set ENV variable `SUN_CIPHER_ID` to hardcoded value `5b9c1065-e39d-4a43-a04a-e59bcea3e03f`
2. Build the image using `sudo docker`, tag it `registry.killer.sh:5000/sun-cipher:v1-docker` and push it to the registry
3. Build the image using `sudo podman`, tag it `registry.killer.sh:5000/sun-cipher:v1-podman` and push it to the registry
4. Run a container using `sudo podman`, which keeps running detached in the background, named `sun-cipher` using image `registry.killer.sh:5000/sun-cipher:v1-podman`
5. Write the logs your container `sun-cipher` produces into `$HOME/ckad-simulation/11/logs`

## Expected Answer

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
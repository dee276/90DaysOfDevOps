# Day 08 - Cloud Server Setup: Docker, Nginx and Web Deployment

## Environment

- Local machine: Windows with Docker Desktop
- Docker context: `desktop-linux`
- Linux practice container: `devops-ubuntu`
- Web server container: `devops-nginx`
- Public cloud instance: not used for this run
- Local web URL: `http://localhost:8088`

This exercise was completed as a local Docker-based deployment because I am working from Windows. The workflow still covers the core DevOps concepts: Linux runtime, containerized service deployment, port exposure, HTTP verification, and log extraction.

## Commands Used

### 1. Check Docker status

```bash
docker version
docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"
```

Purpose: verify that Docker Desktop is running with the Linux engine.

### 2. Create a reusable Ubuntu Linux container

```bash
docker run -d --name devops-ubuntu ubuntu sleep infinity
docker exec devops-ubuntu sh -lc "cat /etc/os-release && uname -a"
```

Purpose: create a reusable Linux environment for practice in future days.

### 3. Run Nginx as a web server

The first attempt used port `8080`, but that port was already in use on Windows.

```bash
docker run -d --name devops-nginx -p 8080:80 nginx:latest
```

Issue:

```text
ports are not available: exposing port TCP 0.0.0.0:8080
```

Fix:

```bash
docker rm devops-nginx
docker run -d --name devops-nginx -p 8088:80 nginx:latest
```

Purpose: expose Nginx from container port `80` to local machine port `8088`.

### 4. Verify web access

```bash
curl.exe -I http://localhost:8088
```

Result:

```text
HTTP/1.1 200 OK
Server: nginx/1.31.2
```

### 5. Extract Nginx logs

```bash
docker logs devops-nginx --tail 50
```

The output was saved in:

```text
nginx-logs.txt
```

## Challenges Faced

- WSL was installed, but no Linux distribution was configured.
- Docker Desktop required elevated access from the local sandbox.
- Port `8080` was already in use, so I changed the mapping to `8088:80`.
- This was a local Docker deployment, not a public cloud deployment, so there is no public instance IP or cloud security group for this run.

## What I Learned

- Docker Desktop can provide a Linux runtime on Windows through the `desktop-linux` engine.
- A container can expose an internal service port to the host using `-p host_port:container_port`.
- Nginx can be verified quickly with `curl -I` by checking for an HTTP `200 OK`.
- Logs are critical for validating service startup and requests.
- Port conflicts are common in real deployments and can be solved by changing the host port mapping.

## Screenshots To Capture Manually

- Docker Desktop showing `devops-nginx` running.
- Browser showing the Nginx welcome page at `http://localhost:8088`.
- Terminal showing `docker logs devops-nginx --tail 50`.

 Sure, here are three Bash scripts to automate setting up the prerequisites, preparing configurations, and launching containers. Save each script separately as follows:

1. **setup\_prereqs.sh:** Contains commands to set up prerequisites such as updating, installing software, granting permissions, etc.

```bash
#!/bin/bash

## Ensure proper execution path and user privileges
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    echo "Please execute via 'source ./setup_prereqs.sh'"
    exit 1
fi

echo "Setting up Prerequisites..."

apt update && apt upgrade -y
apt install docker.io -y
systemctl start docker
systemctl enable docker

exit 0
```

2. **prepare\_configs.sh:** Creates folders, prepares Traefik and NGINX configuration files, and sets up other relevant settings.

```bash
#!/bin/bash

## Ensure proper execution path and user privileges
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    echo "Please execute via 'source ./prepare_configs.sh'"
    exit 1
fi

WORKDIR=$(pwd)
TRAFFIC_FOLDER="${WORKDIR}/traefik"
NGINX_FOLDER="${WORKDIR}/nginx"
mkdir -p ${NGINX_FOLDER}/{certs,config,data,traefik}
cd ${NGINX_FOLDER}/traefik
cat > traefik.toml <<EOL
... # Insert contents of traefik.toml from Step 2 above
EOL
touch acme.json
chmod 600 acme.json

cat > ${NGINX_FOLDER}/config/nginx.conf <<EOL
... # Insert contents of nginx.conf from Step 4 above
EOL

cat > ${NGINX_FOLDER}/nginx-compose.yml <<EOL
... # Insert contents of nginx-compose.yml below
version: '3.9'

services:
  nginx:
    depends_on:
      - traefik
    volumes:
      - "./config/:/etc/nginx/"
      - "./certs/:/etc/letsencrypt/"
      - "./data/:/data/"
      - "./traefik/acme.json:/etc/traefik/acme.json:rw"
    networks:
      - web
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.nginx.rule=Host(\`${NGINX_HOST}\`)"
      - "traefik.http.services.nginx.loadbalancer.server.port=8080"
      - "traefik.docker.network=web"

networks:
  web:
    external: true
EOL

exit 0
```

Replace `...` with the actual contents mentioned in Steps 2 and 4. Make sure to replace `${NGINX_HOST}` in the last code block with your desired hostname (i.e., videogirl.ai).

3. **launch\_containers.sh:** Launches the Traefik and NGINX containers.

```bash
#!/bin/bash

## Ensure proper execution path and user privileges
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    echo "Please execute via 'source ./launch_containers.sh'"
    exit 1
fi

docker network rm web || :
docker network create -d bridge web

docker stop traefik || :
docker rm traefik || :
docker pull traefik:v2.9
docker run \
--detach \
--restart always \
--name=traefik \
--volume="/etc/localtime:/etc/localtime:ro" \
--volume="${NGINX_FOLDER}/traefik/traefik.toml:/etc/traefik/traefik.toml:ro" \
--volume="${NGINX_FOLDER}/traefik/acme.json:/etc/traefik/acme.json:rw" \
--volume="/var/run/docker.sock:/var/run/docker.sock:ro" \
--network=web \
--publish=80:80 \
--publish=443:443 \
--label="traefik.enable=true" \
--label="traefil.http.routers.traefik.rule=Host(`monitor.videogirl.ai`) || PathPrefix(`/traefik`)" \
--label="traefik.http.services.traefik.loadBalancer.server.port=8080" \
--label="traefik.http.middlewares.traefik-auth.basicAuth.users=username:\$apr1\$H6uskqZo\$IgMOkLhASM9SjKOOzyjCe1" \
--label="traefik.http.routers.traefik.middlewares=traefik-auth@docker" \
traefik:v2.9

sleep 5

docker-compose -f ${NGINX_FOLDER}/nginx-compose.yml up -d

exit 0
```

Make all scripts executable before running them:

```bash
chmod +x source_*.sh
```

Then, follow the order:

1. Source `setup_prereqs.sh`
2. Source `prepare_configs.sh`
3. Source `launch_containers.sh`

This process ensures automated setup while allowing you to review the changes made by each script individually. Note that you need to edit the Traefik and NGINX configuration files to match your specific needs.

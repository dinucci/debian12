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

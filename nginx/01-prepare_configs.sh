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

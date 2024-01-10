#!/bin/bash

# Función para verificar la instalación de Docker
function check_docker() {
  if ! command -v docker &> /dev/null; then
    echo "Error: Docker no encontrado."
    echo "Instale Docker e inténtelo de nuevo:"
    echo "curl -fsSL https://get.docker.com | sh"
    return 1
  fi
}

# Verificamos la presencia de Docker
check_docker

# Definimos variables útiles
readonly DOCKER_IMAGE="nginx:latest"
readonly DOCKER_COMPOSE="docker-compose"
readonly SERVICE_NAME="nginx"
readonly RUNTIME_OPTIONS="-d"
readonly PORTS="-p 80:80 -p 443:443"
readonly NETWORK="nginx-net"
readonly VOLUMES="-v $(pwd)/nginx.conf:/etc/nginx/nginx.conf -v $(pwd)/app:/app"

# Crear la red personalizada, sólo si no existe
if ! docker network inspect $NETWORK &> /dev/null; then
  echo "Creando red '$NETWORK'..."
  docker network create $NETWORK
fi

# Arrancar el servicio NGINX utilizando docker-compose
echo "Arrancando '$SERVICE_NAME' ($DOCKER_IMAGE)..."
$DOCKER_COMPOSE down --remove-orphans || :
$DOCKER_COMPOSE up $RUNTIME_OPTIONS $PORTS $VOLUMES --force-recreate --no-deps $SERVICE_NAME

# Mostrar mensajes relevantes
echo ""
echo "El servicio '$SERVICE_NAME' ha sido arrancado satisfactoriamente."
echo "Utilice el siguiente comando para detener el servicio:"
echo "\tsudo $DOCKER_COMPOSE down --volumes --rmi all"
echo ""
echo "Revise logs del servicio:"
echo "\tdocker-compose logs -f $SERVICE_NAME"
echo ""
echo "Explore otros comandos útiles en:"
echo "\thttps://docs.docker.com/compose/reference/"

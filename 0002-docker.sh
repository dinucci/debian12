#!/bin/bash

# Add the 'test' user to the 'docker' group
apt update && apt upgrade -y
curl -fsSL https://get.docker.com | sh
systemctl enable --now docker
systemctl start docker

groupadd docker
usermod -aG docker test

newgrp docker

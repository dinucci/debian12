#!/bin/bash

# Add the 'amano' user to the 'docker' group
apt update && apt upgrade -y
curl -fsSL https://get.docker.com | sh
systemctl enable --now docker

usermod -aG docker amano


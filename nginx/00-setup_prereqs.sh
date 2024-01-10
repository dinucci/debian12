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

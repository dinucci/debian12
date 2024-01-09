#!/bin/bash

# Update package list
apt-get update

# Install Docker
apt-get install -y docker.io

# Start Docker service
systemctl start docker

# Pull the Nginx image
docker pull nginx

# Run the Nginx container
docker run --name videogirl_nginx \
    -p 80:80 \
    -p 443:443 \
    -e VIRTUAL_HOST=server.ai \
    -e LETSENCRYPT_EMAIL=your_email@example.com \
    -d nginx

# Generate self-signed certificate (optional)
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt -subj "/C=US/ST=State/L=City/O=Organization/CN=localhost"

# Configure Nginx
cat > /etc/nginx/conf.d/default.conf <<EOF
server {
    listen       80;
    server_name  localhost;
}

server {
    listen      443 ssl http2;
    server_name server.ai;

    # Self-signed certificate
    ssl_certificate     /etc/ssl/certs/nginx-selfsigned.crt;
    ssl_certificate_key /etc/ssl/private/nginx-selfsigned.key;

    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
    }
}
EOF

# Restart Nginx
service nginx restart

#!/bin/bash

# Install Nginx
sudo apt update
sudo apt install -y nginx

# Remove default Nginx configuration
sudo rm /etc/nginx/sites-enabled/default

# Create a new server block for videogirl.ai
cat > /etc/nginx/sites-available/videogirl.ai <<EOF
server {
    listen 80;
    listen [::]:80;
    server_name videogirl.ai www.videogirl.ai;
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name videogirl.ai www.videogirl.ai;

    # Set up SSL certificate with Let's Encrypt
    include letsencrypt/options-ssl-nginx.conf;
    include letsencrypt/ssl-dhparams.pem;
    ssl_certificate /etc/letsencrypt/live/videogirl.ai/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/videogirl.ai/privkey.pem;

    # Enable HTTPS Strict Transport Security (HSTS)
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains";

    # Serve static files from /var/www/videogirl.ai
    root /var/www/videogirl.ai;
    index index.html index.htm;

    location / {
        try_files $uri $uri/ =404;
    }

    # Include A-Frame configuration if present
    if (-e /etc/nginx/aframe.conf) {
        include /etc/nginx/aframe.conf;
    }
}
EOF

# Enable the server block by creating a symlink in sites-enabled
sudo ln -s /etc/nginx/sites-available/videogirl.ai /etc/nginx/sites-enabled/

# Create separate storage directory for videogirl.ai
sudo mkdir /var/www/videogirl.ai
sudo chown -R $USER:$USER /var/www/videogirl.ai

# Install Let's Encrypt client
sudo add-apt-repository ppa:certbot/certbot
sudo apt update
sudo apt install -y certbot python3-certbot-nginx

# Obtain SSL certificate from Let's Encrypt
sudo certbot --non-interactive --agree-tos --email your@email.com --nginx -d videogirl.ai -d www.videogirl.ai

# Restart Nginx to apply changes
sudo systemctl restart nginx

# Optionally create an A-Frame configuration file at /etc/nginx/aframe.conf
cat > /etc/nginx/aframe.conf <<EOF
location /aframe-scene {
    alias /path/to/your/aframe-scene/;
    try_files \$uri \$uri/ =404;
}
EOF

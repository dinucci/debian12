#!/bin/bash

# Update packages and install necessary tools
sudo apt update -y && sudo apt upgrade -y
sudo apt install -y curl wget vim ufw

# Set up the firewall
sudo ufw allow OpenSSH
sudo ufw enable

# Create a new user and give them sudo privileges
adduser <username>
usermod -aG sudo <username>

# Configure SSH daemon to use key authentication
ssh_config="/etc/ssh/sshd_config"
sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' $ssh_config
sed -i 's/#AuthorizedKeysFile      .ssh\/authorized_keys/AuthorizedKeysFile      .ssh\/authorized_keys/' $ssh_config
systemctl restart ssh

# Disable password login via SSH
sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' $ssh_config
systemctl restart ssh

# Enable automatic security updates
unattended-upgrade --install --auto-update

# Set timezone
timedatectl set-timezone America/Los_Angeles

# Install fail2ban for brute force protection
apt-get install -y fail2ban
cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
sed -i 's/#bantime = 600/bantime = 86400/' /etc/fail2ban/jail.local
sed -i 's/#findtime = 7200/findtime = 3600/' /etc/fail2ban/jail.local
service fail2ban start

echo "Initial server setup complete."

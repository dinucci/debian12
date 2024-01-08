#!/bin/bash

# Replace <username> with your desired username. This script will perform the following tasks:

# Updates and upgrades all installed packages
# Installs essential tools (curl, wget, vim, ufw)
# Sets up the UFW firewall and allows OpenSSH traffic
# Creates a new user and adds them to the sudo group
# Configures SSH daemon to use key authentication instead of passwords
# Enables automatic security updates
# Sets the system time zone
# Installs Fail2Ban for brute force attack prevention
# Note that you should replace some values such as the timezone according to your need

# Update packages and install necessary tools
apt update -y && apt upgrade -y
apt install -y git curl wget vim ufw apt-mirror

# Set up the firewall
ufw allow OpenSSH
ufw enable

# Create a new user and give them sudo privileges
adduser test
usermod -aG sudo test

# Configure SSH daemon to use key authentication
ssh_config="/etc/ssh/sshd_config"
sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' $ssh_config
sed -i 's/#AuthorizedKeysFile      .ssh\/authorized_keys/AuthorizedKeysFile      .ssh\/authorized_keys/' $ssh_config
systemctl restart ssh

# Disable password login via SSH
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' $ssh_config
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

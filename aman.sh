#!/bin/bash

# Set default values
username="user"
password="root"
chrome_remote_desktop_url="https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb"

# Function to log messages
log() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $1"
}

# Function to install packages
install_package() {
    package_url=$1
    log "Downloading $package_url"
    wget -q --show-progress "$package_url"
    log "Installing $(basename $package_url)"
    sudo dpkg --install $(basename $package_url)
    log "Fixing broken dependencies"
    sudo apt-get install --fix-broken -y
    rm $(basename $package_url)
}

# Installation steps
log "Starting installation"

# Create user
log "Creating user '$username'"
sudo useradd -m "$username"
echo "$username:$password" | sudo chpasswd
sudo sed -i 's/\/bin\/sh/\/bin\/bash/g' /etc/passwd

# Install Chrome Remote Desktop
install_package "$chrome_remote_desktop_url"

# Install XFCE desktop environment
log "Installing XFCE desktop environment"
sudo DEBIAN_FRONTEND=noninteractive apt-get install --assume-yes -y xfce4 desktop-base dbus-x11 xscreensaver

# Set up Chrome Remote Desktop session
log "Setting up Chrome Remote Desktop session"
sudo bash -c 'echo "exec /etc/X11/Xsession /usr/bin/xfce4-session" > /etc/chrome-remote-desktop-session'

# Disable lightdm service
log "Disabling lightdm service"
sudo systemctl disable lightdm.service

# Install Firefox ESR
log "Installing Firefox ESR"
echo | sudo add-apt-repository ppa:mozillateam/ppa || { log "Failed to add Firefox ESR repository"; exit 1; }
sudo apt update || { log "Failed to update package lists"; exit 1; }
sudo apt install firefox-esr -y || { log "Failed to install Firefox ESR"; exit 1; }
sudo apt-get install --fix-broken -y || { log "Failed to fix broken dependencies after Firefox ESR installation"; exit 1; }

log "Installation completed successfully"

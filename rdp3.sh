#!/bin/bash

# Set default username and password
username="user"
password="root"

# Set default CRP value
CRP=""

# Set default Pin value
Pin="123456"

# Set default Autostart value
Autostart=true

echo "Creating User and Setting it up"
sudo useradd -m "$username"
sudo adduser "$username" sudo
echo "$username:$password" | sudo chpasswd
sudo sed -i 's/\/bin\/sh/\/bin\/bash/g' /etc/passwd
echo "User created and configured with username '$username' and password '$password'"

echo "Installing necessary packages"
sudo apt update
sudo apt install -y xfce4 desktop-base xfce4-terminal tightvncserver wget

echo "Setting up Chrome Remote Desktop"
echo "Installing Chrome Remote Desktop"
wget https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb
sudo dpkg --install chrome-remote-desktop_current_amd64.deb
sudo apt install --assume-yes --fix-broken

echo "Installing Desktop Environment"
export DEBIAN_FRONTEND=noninteractive
sudo apt install --assume-yes xfce4 desktop-base xfce4-terminal
echo "exec /etc/X11/Xsession /usr/bin/xfce4-session" | sudo tee /etc/chrome-remote-desktop-session
sudo apt remove --assume-yes gnome-terminal
sudo apt install --assume-yes xscreensaver
sudo systemctl disable lightdm.service

echo "Installing Google Chrome"
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg --install google-chrome-stable_current_amd64.deb
sudo apt install --assume-yes --fix-broken

# Prompt user for CRP value
read -p "Enter CRP value: " CRP

echo "Finalizing"
if [ "$Autostart" = true ]; then
    mkdir -p "/home/$username/.config/autostart"
    link="https://youtu.be/d9ui27vVePY?si=TfVDVQOd0VHjUt_b"
    colab_autostart="[Desktop Entry]\nType=Application\nName=Colab\nExec=sh -c 'sensible-browser $link'\nIcon=\nComment=Open a predefined notebook at session signin.\nX-GNOME-Autostart-enabled=true"
    echo -e "$colab_autostart" | sudo tee "/home/$username/.config/autostart/colab.desktop"
    sudo chmod +x "/home/$username/.config/autostart/colab.desktop"
    sudo chown "$username:$username" "/home/$username/.config"
fi

sudo adduser "$username" chrome-remote-desktop
command="$CRP --pin=$Pin"
sudo su - "$username" -c "$command"
sudo service chrome-remote-desktop start

echo "Finished Successfully"
while true; do sleep 10; done

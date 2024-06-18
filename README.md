# Chrome Remote Desktop Setup Script

This repository contains a bash script to automate the installation and configuration of Chrome Remote Desktop on a Linux system. The script also installs the XFCE desktop environment and Firefox browser, and creates a new user.

## Features

- Creates a new user with specified username and password
- Installs Chrome Remote Desktop
- Sets up the XFCE desktop environment
- Configures Chrome Remote Desktop to use XFCE
- Disables the LightDM service
- Installs Firefox browser

## Prerequisites

- A Debian-based Linux distribution (e.g., Ubuntu)
- `sudo` privileges to run the script

## Usage

1. **Clone the Repository**

    ```bash
    git clone https://github.com/epic-miner/RDP
    cd RDP
    ```

2. **Edit the Script (optional)**

    Modify the `username` and `password` variables at the top of the `install.sh` script if needed.

3. **Run the Script**

    ```bash
    sudo sh aman.sh
    ```
4. **(optional) run scrypt**

   ```bash
   sudo sh rdp3.sh
   ```
   
    This script must be run with `sudo` to perform the necessary system changes.

## Script Breakdown

- **Set Default Values**
    ```bash
    username="user"
    password="root"
    chrome_remote_desktop_url="https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb"
    ```

- **Log Function**
    Logs messages with timestamps for better traceability.
    ```bash
    log() {
        echo "$(date +'%Y-%m-%d %H:%M:%S') - $1"
    }
    ```

- **Install Package Function**
    Downloads and installs a package from a given URL.
    ```bash
    install_package() {
        package_url=$1
        log "Downloading $package_url"
        if wget -q --show-progress "$package_url"; then
            log "Installing $(basename $package_url)"
            if sudo dpkg --install $(basename $package_url); then
                log "Fixing broken dependencies"
                sudo apt-get install --fix-broken -y
                rm $(basename $package_url)
            else
                log "Failed to install $(basename $package_url)"
                exit 1
            fi
        else
            log "Failed to download $package_url"
            exit 1
        fi
    }
    ```

- **Installation Steps**
    - Logs the start of the installation.
    - Creates a new user with the provided username and password.
    - Installs Chrome Remote Desktop.
    - Installs the XFCE desktop environment.
    - Sets up the Chrome Remote Desktop session to use XFCE.
    - Disables the `lightdm` service.
    - Installs Firefox ESR.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request with your changes.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

#!/usr/bin/env bash
#
# pacman option .sh
# Installs git, curl, netbird with management self hosted 


set -euo pipefail

# --- must be root ----------------------------------------------------------
if [[ "${EUID}" -ne 0 ]]; then
    echo "This script must be run as root (use 'sudo $0' or run it after 'su -')." >&2
    exit 1
fi

sudo pacman -S --noconfirm git
sudo pacman -Sy --noconfirm curl
curl -fsSL https://pkgs.netbird.io/install.sh | sh
netbird up -m https://netbird.rcmtoolkit.com/
sudo pacman -S --noconfirm remmina freerdp   
##or sudo apt update && sudo apt install -y remmina remmina-plugin-rdp remmina-plugin-secret
echo
echo "Done"

#!/usr/bin/env bash
#
# setup-desktop.sh
# Installs sudo, adds user 'crisb' to the sudo group, and installs a
# minimal Xfce desktop with LightDM.
#
# Run as root:   su -    then   ./setup-desktop.sh
#           or:  sudo ./setup-desktop.sh

set -euo pipefail

# --- must be root ----------------------------------------------------------
if [[ "${EUID}" -ne 0 ]]; then
    echo "This script must be run as root (use 'sudo $0' or run it after 'su -')." >&2
    exit 1
fi

# --- refresh package lists first ------------------------------------------
apt update

# --- sudo ------------------------------------------------------------------
apt install -y sudo
/usr/sbin/usermod -aG sudo crisb

# --- X server + display manager + desktop ---------------------------------
apt install -y xorg
apt install -y lightdm
apt install -y xfce4 xfce4-terminal

echo
echo "Done. Reboot to start LightDM, or run 'systemctl start lightdm'."
echo "'crisb' has been added to the sudo group (re-login for it to take effect)."

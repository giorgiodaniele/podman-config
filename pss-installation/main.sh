#!/bin/bash
#
#
# Autore:      Giorgio Daniele Luppina
# Data:        2025-01-14
# Descrizione: Inizializzazione Podman System Service
#
#

#############################################################################
###########    ATTENZIONE: richiede privilegi amministrativi !!!   ##########
#############################################################################

USER=tcuser
UUID=1000
GROUP=tcuser

echo "[INFO]: installazione configurazioni di ovverride per podman.service..."
install -d -o "$USER" -g "$GROUP" -m 0755 "/home/$USER/.config/systemd/user/podman.service.d"
install    -o "$USER" -g "$GROUP" -m 0644 override.conf "/home/$USER/.config/systemd/user/podman.service.d/ovveride.conf"

echo "[INFO]: installazione configurazioni del logging del podman.service..."
install -d -o "$USER" -g "$GROUP" -m 0755 "/var/log/app/podman"
install    -o root    -g root     -m 0644 podman.log "/etc/logrotate.d/podman"

echo "[INFO]: abilitazione del podman.socket e del podman.service..."
sudo -u "$USER" XDG_RUNTIME_DIR="/run/user/$UUID" systemctl --user daemon-reload
sudo -u "$USER" XDG_RUNTIME_DIR="/run/user/$UUID" systemctl --user enable --now podman.socket
sudo -u "$USER" XDG_RUNTIME_DIR="/run/user/$UUID" systemctl --user enable --now podman.service
sudo -u "$USER" XDG_RUNTIME_DIR="/run/user/$UUID" systemctl --user start  --now podman.service
sudo -u "$USER" XDG_RUNTIME_DIR="/run/user/$UUID" systemctl --user start  --now podman.socket


chown -R "$USER":"$USER" /home/$USER/.config
chown -R "$USER":"$USER" /var/log/app/podman

echo
echo "FATTO!"
echo

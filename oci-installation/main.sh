#!/bin/bash
#
#
# Autore:      Giorgio Daniele Luppina
# Data:        2025-01-14
# Descrizione: Inizializzazione OCI Registry
#
#

#############################################################################
###########    ATTENZIONE: richiede privilegi amministrativi !!!   ##########
#############################################################################


USER=tcuser
UUID=1000
GROUP=tcuser


echo "[INFO]: installazione docker-compose..."
install -d -o "$USER" -g "$GROUP" -m 0755 "/home/$USER/.docker/cli-plugins"
install    -o "$USER" -g "$GROUP" -m 0755 docker-compose "/home/$USER/.docker/cli-plugins/docker-compose"

echo "[INFO]: installazione albero cartelle del registro OCI..."
install -d -o "$USER" -g "$GROUP" -m 0755 /tools/podreg
install -d -o "$USER" -g "$GROUP" -m 0755 /tools/podreg/conf
install -d -o "$USER" -g "$GROUP" -m 0755 /tools/podreg/certs
install -d -o "$USER" -g "$GROUP" -m 0755 /tools/podreg/registry

echo "[INFO]: installazione configurazioni del registro OCI..."
install -o "$USER" -g "$GROUP" -m 0644 docker-compose.yml /tools/podreg/conf/docker-compose.yml
install -o "$USER" -g "$GROUP" -m 0644 config.yml         /tools/podreg/conf/config.yml

echo "[INFO]: installazione configurazioni del logging del registro OCI..."
install -d -o "$USER" -g "$GROUP" -m 0755 /var/log/app/podreg

echo "[INFO]: installazione del podreg.service in systemd..."
install -d -o "$USER" -g "$GROUP" -m 0755 "/home/$USER/.config/systemd/user"
install    -o "$USER" -g "$GROUP" -m 0644 podreg.service "/home/$USER/.config/systemd/user/podreg.service"

echo "[INFO]: installazione opzioni di rotazione dei log per podreg.service..."
install -o root -g root -m 0644 podreg.log /etc/logrotate.d/podreg

echo "[INFO]: abilitazione del podreg.service..."
sudo -u "$USER" XDG_RUNTIME_DIR="/run/user/$UUID" systemctl --user daemon-reload
sudo -u "$USER" XDG_RUNTIME_DIR="/run/user/$UUID" systemctl --user enable --now podreg.service
sudo -u "$USER" XDG_RUNTIME_DIR="/run/user/$UUID" systemctl --user start  --now podreg.service


chown -R "$USER":"$USER" /home/$USER/.config
chown -R "$USER":"$USER" /home/$USER/.docker
chown -R "$USER":"$USER" /tools
chown -R "$USER":"$USER" /var/log/app/podreg

echo
echo "DONE!"
echo

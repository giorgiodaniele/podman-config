#!/usr/bin/env bash
#
# Author:      Giorgio Daniele Luppina
# Date:        2025-01-13
# Description: Rollback Podman PSS and OCI Registry setup
#
#


USER=tcuser
UUID="1000"
GROUP=tcuser


echo "[INFO]: rimozione podman.service, podman.socket e podreg.service..."
sudo -u "$USER" XDG_RUNTIME_DIR="/run/user/$UUID" systemctl --user disable --now podman.service podman.socket || true
sudo -u "$USER" XDG_RUNTIME_DIR="/run/user/$UUID" systemctl --user disable --now podreg.service || true
sudo -u "$USER" XDG_RUNTIME_DIR="/run/user/$UUID" systemctl --user daemon-reload || true

echo "[INFO]: rimozione podman.service ed override..."
rm -f  "/home/$USER/.config/systemd/user/podreg.service"
rm -rf "/home/$USER/.config/systemd/user/podman.service.d"


echo "[INFO]: rimozione installazione docker-compose..."
rm -f "/home/$USER/.docker/cli-plugins/docker-compose"
rmdir --ignore-fail-on-non-empty "/home/$USER/.docker/cli-plugins" || true
rmdir --ignore-fail-on-non-empty "/home/$USER/.docker" || true

echo "[INFO]: rimozione installazione registro..."
rm -rf /tools/podreg

echo "[INFO]: rimozione dei log..."
rm -rf /var/log/app/podman
rm -rf /var/log/app/podreg

echo "[INFO]: rimozione configurazioni di log..."
rm -f /etc/logrotate.d/podman
rm -f /etc/logrotate.d/podreg


# loginctl disable-linger "$USER" || true
# setenforce 1

echo
echo "ROLLBACK COMPLETED"
echo

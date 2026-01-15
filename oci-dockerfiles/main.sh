#!/bin/bash
#
# Autore:      Giorgio Daniele Luppina
# Data:        2025-01-14
# Descrizione: Installazione e caricamento di container maven JDK8 e JDK11
#
#

REGISTRY=localhost:5000
USER=tcuser
USERNAME=myuser
PASSWORD=mypass
AUTH_FILE=/home/$USER/.docker/auth.json


echo "[INFO]: creazione immagine maven 3.5 con JDK8  da caricare su $REGISTRY..."
podman build -f jdk8.Dockerfile  -t "$REGISTRY"/maven:3.5-jdk-8-rootless  .

echo "[INFO]: creazione immagine maven 3.5 con JDK11 da caricare su $REGISTRY..."
podman build -f jdk11.Dockerfile -t "$REGISTRY"/maven:3.5-jdk-11-rootless .

#
#
# NOTA: 
#    Una volta che le immagini sono state generate, possiamo caricarle nel 
#    registry.
#
#    Quando si effettua il login al registry, Podman genera il file auth.json
#    posizionato in XDG_RUNTIME_DIR=/run/user/containers/<uid>; tuttavia, dopo
#    il riavvio del sistema questo file di configurazione viene eliminato.
#
#    Per far sì che sopravviva ai riavvii, copiare il file auth.json generato
#    nella seconda posizione predefinita, che è /home/<user>/.docker/
#
#

echo "[INFO] Logging in $REGISTRY"
# podman login -u $USER -p $PASS $REGISTRY --verbose --authfile="$AUTH"
podman login -u $USERNAME -p $PASSWORD $REGISTRY --verbose
cp     /run/user/$UUID/containers/auth.json /home/$USER/.docker/
rm     /run/user/$UUID/auth.json
chown  "$USER":"$USER" /run/user/$UUID/auth.json

echo "[INFO]: caricamento immagine maven 3.5 con JDK8..."
podman push "$REGISTRY"/maven:3.5-jdk-8-rootless

echo "[INFO]: caricamento immagine maven 3.5 con JDK11..."
podman push "$REGISTRY"/maven:3.5-jdk-11-rootless
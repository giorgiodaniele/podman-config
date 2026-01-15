#!/bin/bash
#
#
# Autore:      Giorgio Daniele Luppina
# Data:        2025-01-14
# Descrizione: Inizializzazione installazione podman
#
#

#############################################################################
###########    ATTENZIONE: richiede privilegi amministrativi !!!   ##########
#############################################################################

USER=tcuser
UUID=1000
GROUP=tcuser

# Aggiornamento/Installazione del software alle versioni compatibili con l'ambiente di sviluppo
CRUN_VERSION=1.16.1
PODMAN_VERSION=5.4.0

dnf install -y podman-5:${PODMAN_VERSION}-13.el9_6 -y crun-${CRUN_VERSION}-1.el9

#    NOTA:
#    In caso di errori, si ricorda che l'installazione di software
#    in ambiente Red Hat è legato alla configurazione repositories 
#    dell'hosto.
#    Con utenza privilegiata, si consiglia di visualizzare la lista
#    dei repositories configuati:
#
#         dnf repolist
#              [...]
#              repo id                           repo name
#              rhel-9-for-x86_64-appstream-rpms  Red Hat Enterprise Linux 9 for x86_64 - AppStream (RPMs)
#              rhel-9-for-x86_64-baseos-rpms     Red Hat Enterprise Linux 9 for x86_64 - BaseOS (RPMs)

#    E' possibile visualizzare le versioni disponibili per un dato pacchetto
#    attraverso i comandi:
#         dnf list 
#    oppure, se si conosce il nome
#         dfn list --showduplicates <nompacchetto>
#
#

#
#
# Verifica backends
#
#

podman_version=$(podman version --format '{{.Client.Version}}')
oci_name=$(podman info --format '{{.Host.OCIRuntime.Name}}')
oci_version=$(podman info --format '{{.Host.OCIRuntime.Version}}')
net_name=$(podman info --format '{{.Host.NetworkBackend}}')

echo "......................................"
echo "[INFO]: Podman versione  : ${podman_version}"
echo "[INFO]: OCI runtime      : ${oci_name} ${oci_version}"
echo "[INFO]: Network backend  : ${net_name}"
echo "......................................"

#
# Ultime configurazioni
#

loginctl   enable-linger "$USER"        # consente ad un utente (come root) di eseguire comandi
setenforce 0                            # disabilita SELinux

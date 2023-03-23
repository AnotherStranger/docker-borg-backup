#!/bin/bash

echo "################################################################################"
echo "#                          STARTING BORGBACKUP-SERVER                          #"
echo "################################################################################"
echo ""

mkdir -p /var/lib/docker-borg/ssh >/dev/null 2>&1
mkdir -p /home/borg/backups >/dev/null 2>&1

# Create a random password each startup, as only ssh-key auth is allowed
BORG_PASSWORD=$(openssl passwd -5 "$(openssl rand -base64 128)")
usermod -p "$BORG_PASSWORD" borg > /dev/null
usermod -U borg > /dev/null

# Generate SSH host-key, if not present
if [ ! -f /var/lib/docker-borg/ssh/ssh_host_rsa_key ]; then
    echo "Creating SSH keys. To persist keys across container updates, mount a volume to /var/lib/docker-borg..."
    ssh-keygen -A
    mv /etc/ssh/ssh*key* /var/lib/docker-borg/ssh/
fi
# Ensure correct permisiions for ssh keys
chmod -R og-rwx /var/lib/docker-borg/ssh/

ln -sf /var/lib/docker-borg/ssh/* /etc/ssh >/dev/null 2>&1

if [ -n "${BORG_UID}" ]; then
    usermod -u "${BORG_UID}" borg > /dev/null
fi

if [ -n "${BORG_GID}" ]; then
    groupmod -o -g "${BORG_GID}" borg
    usermod -g "${BORG_GID}" borg > /dev/null
fi

if [ -n "${BORG_AUTHORIZED_KEYS+x}" ]; then
    echo -e "${BORG_AUTHORIZED_KEYS}" | sed  -e "s/^/command=\"borg serve ${BORG_SERVE_ADDITIONAL_ARGS} --restrict-to-path \/home\/borg\/backups\" /"  >/home/borg/.ssh/authorized_keys
    chown borg:borg /home/borg/.ssh/authorized_keys
    chmod og-rwx /home/borg/.ssh/authorized_keys

    echo "################################################################################"
    echo "#          PRINTING THE CONTENTS OF /HOME/BORG/.SSH/AUTHORIZED_KEYS:           #"
    echo "################################################################################"
    cat /home/borg/.ssh/authorized_keys
    echo "end of /home/borg/.ssh/authorized_keys"
    echo ""
fi

chown -R borg:borg /home/borg
chown -R borg:borg /home/borg/.ssh

echo "################################################################################"
echo "#                    BORGBACKUP SERVER STARTED SUCCESSFULLY                    #"
echo "################################################################################"
echo "Environment:"
echo "   BORG_UID                   = ${BORG_UID}"
echo "   BORG_GID                   = ${BORG_GID}"
echo "   BORG_SERVE_ADDITIONAL_ARGS = ${BORG_SERVE_ADDITIONAL_ARGS}"
echo "Borg Version: $(borg --version)"
echo "Following borg repos are present:"
du -sh /home/borg/backups/*
echo "Size of all backups combined: $(du -sh /home/borg/backups)"


exec /usr/sbin/sshd -D -e

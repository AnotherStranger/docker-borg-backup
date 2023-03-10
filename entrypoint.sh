#!/bin/bash

echo "Starting borgbackup-server...."
echo "Environment:"
echo "   BORG_UID                   = ${BORG_UID}"
echo "   BORG_GID                   = ${BORG_GID}"
echo "   BORG_SERVE_ADDITIONAL_ARGS = ${BORG_SERVE_ADDITIONAL_ARGS}"
echo "   BORG_AUTHORIZED_KEYS       = ${BORG_AUTHORIZED_KEYS}"
echo ""

mkdir -p /var/lib/docker-borg/ssh >/dev/null 2>&1
mkdir -p /home/borg/backups

if [ ! -f /var/lib/docker-borg/ssh/ssh_host_rsa_key ]; then
    echo "Creating SSH keys. To persist keys across container updates, mount a volume to /var/lib/docker-borg..."
    ssh-keygen -A
    mv /etc/ssh/ssh*key* /var/lib/docker-borg/ssh/
fi

ln -sf /var/lib/docker-borg/ssh/* /etc/ssh >/dev/null 2>&1

if [ -n "${BORG_UID}" ]; then
    usermod -u "${BORG_UID}" borg
fi

if [ -n "${BORG_GID}" ]; then
    groupmod -o -g "${BORG_GID}" borg
    usermod -g "${BORG_GID}" borg
fi

if [ -n "${BORG_AUTHORIZED_KEYS+x}" ]; then
    echo -e "${BORG_AUTHORIZED_KEYS}" | sed  -e "s/^/command=\"borg serve ${BORG_SERVE_ADDITIONAL_ARGS} --restrict-to-path \/home\/borg\/backups\" /"  >/home/borg/.ssh/authorized_keys
    chown borg:borg /home/borg/.ssh/authorized_keys
    chmod og-rwx /home/borg/.ssh/authorized_keys

    echo "Printing the contents of /home/borg/.ssh/authorized_keys:"
    cat /home/borg/.ssh/authorized_keys
fi

chown -R borg:borg /home/borg
chown -R borg:borg /home/borg/.ssh

exec /usr/sbin/sshd -D -e

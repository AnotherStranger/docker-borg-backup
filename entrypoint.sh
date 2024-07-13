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

# if BORG_AUTHORIZED_KEYS is set substitute authorized_keys file
if [ -n "${BORG_AUTHORIZED_KEYS+x}" ]; then
    echo -e "${BORG_AUTHORIZED_KEYS}" | sed -re "/^\\s*(\$|#)/! s/^/restrict,command=\"borg serve ${BORG_SERVE_ADDITIONAL_ARGS} --restrict-to-path \/home\/borg\/backups\" /"  >/home/borg/.ssh/authorized_keys
fi
chown borg:borg /home/borg/.ssh/authorized_keys
chmod og-rwx /home/borg/.ssh/authorized_keys

echo "################################################################################"
echo "#          PRINTING THE CONTENTS OF /HOME/BORG/.SSH/AUTHORIZED_KEYS:           #"
echo "################################################################################"
cat /home/borg/.ssh/authorized_keys
echo "end of /home/borg/.ssh/authorized_keys"
echo ""

# chown the backups, can be deactivated by setting ENSURE_BACKUP_PERMISSIONS to false
if [ "${ENUSURE_BACKUP_PERMISSIONS}" = true ]; then
    chown -R borg:borg /home/borg/backups
else
    echo "I will not ensure the correct permissions, because \$ENSURE_BACKUP_PERMISSIONS is not true."
    echo ""
fi

# Ensure that the ssh keys have the correct permissions
chown -R borg:borg /home/borg/.ssh

echo "################################################################################"
echo "#                    BORGBACKUP SERVER STARTED SUCCESSFULLY                    #"
echo "################################################################################"
echo "Environment:"
echo "   BORG_UID                   = ${BORG_UID}"
echo "   BORG_GID                   = ${BORG_GID}"
echo "   BORG_SERVE_ADDITIONAL_ARGS = ${BORG_SERVE_ADDITIONAL_ARGS}"
echo "   ENUSURE_BACKUP_PERMISSIONS = ${ENUSURE_BACKUP_PERMISSIONS}"
echo "Borg Version: $(borg --version)"
echo "Following borg repos are present:"
du -sh /home/borg/backups/*
echo "Size of all backups combined: $(du -sh /home/borg/backups)"

echo ""
echo "It is recommended to add the following entry to your clients ~/.ssh/config:"
echo "Host borgbackup"
echo "    Hostname <IP_OR_HOST_HERE>"
echo "    User borg"
echo "    Port <PORT>"
echo "    ServerAliveInterval 10"
echo "    ServerAliveCountMax 30"
echo "    IdentityFile <OPTIONAL_PATH_TO_YOUR_KEYFILE>"
echo ""
echo "For further information refer to: https://borgbackup.readthedocs.io/en/stable/usage/serve.html#ssh-configuration"

exec /usr/sbin/sshd -D -e

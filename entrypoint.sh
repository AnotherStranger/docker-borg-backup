#!/bin/bash

dpkg-reconfigure openssh-server

if [ -n "${BORG_UID}" ]; then
    usermod -u ${BORG_UID} borg
fi

if [ -n "${BORG_GID}" ]; then
    groupmod -o -g ${BORG_GID} borg
    usermod -g ${BORG_GID} borg
fi

if [ ! -z ${BORG_AUTHORIZED_KEYS+x} ]; then
    echo $BORG_AUTHORIZED_KEYS > /home/borg/.ssh/authorized_keys
    chown borg.borg /home/borg/.ssh/authorized_keys
fi

exec /usr/sbin/sshd -D

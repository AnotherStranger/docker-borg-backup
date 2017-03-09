#!/bin/bash

dpkg-reconfigure openssh-server

if [ ! -z ${BORG_AUTHORIZED_KEYS+x} ]; then
    echo $BORG_AUTHORIZED_KEYS > /home/borg/.ssh/authorized_keys
    chown borg.borg /home/borg/.ssh/authorized_keys
fi

exec /usr/sbin/sshd -D

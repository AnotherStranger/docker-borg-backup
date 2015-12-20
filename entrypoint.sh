#!/bin/bash

dpkg-reconfigure openssh-server

echo $BORG_AUTHORIZED_KEYS > /home/borg/.ssh/authorized_keys
chown borg.borg /home/borg/.ssh/authorized_keys

exec /usr/sbin/sshd -D

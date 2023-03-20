FROM alpine:3

# Pin package Versions
ARG BORGBACKUP_VERSION="1.2.2-r1"
ARG OPENSSH_VERSION="9.1_p1-r2"
ARG SED_VERSION="4.9-r0"
ARG BASH_VERSION="5.2.15-r0"
ARG SHADOW_VERSION="4.13-r0"
ARG OPENSSL_VERSION="3.0.8-r0"

# Add author and github link to image metadata
LABEL org.opencontainers.image.authors="André Büsgen <andre.buesgen@posteo.de>"
LABEL org.opencontainers.image.source="https://github.com/AnotherStranger/docker-borg-backup"

ENV BORG_SERVE_ADDITIONAL_ARGS=""
ENV BORG_UID=""
ENV BORG_GID=""
ENV BORG_AUTHORIZED_KEYS=""

RUN set -x \
    && apk add --no-cache borgbackup="${BORGBACKUP_VERSION}" openssh-server="${OPENSSH_VERSION}" sed="${SED_VERSION}" bash="${BASH_VERSION}" shadow="${SHADOW_VERSION}" openssl="${OPENSSL_VERSION}"\
    && adduser -D -u 500 borg borg  \
    && mkdir -p /var/run/sshd /var/backups/borg /var/lib/docker-borg/ssh \
    && mkdir /home/borg/.ssh \
    && chown borg:borg /home/borg/.ssh \
    && chmod 700 /home/borg/.ssh


RUN set -x \
    && sed -i \
        -e 's/^#PasswordAuthentication yes$/PasswordAuthentication no/g' \
        -e 's/^PermitRootLogin without-password$/PermitRootLogin no/g' \
        -e 's/^X11Forwarding yes$/X11Forwarding no/g' \
        -e 's/^#LogLevel .*$/LogLevel ERROR/g' \
        /etc/ssh/sshd_config

VOLUME ["/home/borg/backups/", "/var/lib/docker-borg"]

COPY ./entrypoint.sh /


EXPOSE 22
CMD ["/entrypoint.sh"]

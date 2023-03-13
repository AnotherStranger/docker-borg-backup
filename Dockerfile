FROM fedora:37

# Pin package Versions
ARG BORGBACKUP_VERSION="1.2.3"
ARG OPENSSH_VERSION="8.8p1"

# Add author and github link to image metadata
LABEL org.opencontainers.image.authors="André Büsgen <andre.buesgen@posteo.de>"
LABEL org.opencontainers.image.source="https://github.com/AnotherStranger/docker-borg-backup"

ENV BORG_SERVE_ADDITIONAL_ARGS=""
ENV BORG_UID=""
ENV BORG_GID=""
ENV BORG_AUTHORIZED_KEYS=""

RUN set -x \
    && dnf --refresh install -y borgbackup-"${BORGBACKUP_VERSION}" openssh-server-"${OPENSSH_VERSION}" \
    && dnf clean all \
    && useradd --system --uid 500 -m borg \
    && mkdir -p /var/run/sshd /var/backups/borg /var/lib/docker-borg/ssh \
    && mkdir /home/borg/.ssh \
    && chown borg:borg /var/backups/borg /home/borg/.ssh \
    && chmod 700 /home/borg/.ssh \
    && rm -rf /var/lib/apt/lists/*

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

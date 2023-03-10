FROM fedora:37

# hadolint ignore=DL3041
RUN set -x \
    && dnf --refresh install -y borgbackup openssh-server \
    && dnf clean all \
    && useradd --system --uid 500 -m borg \
    && mkdir -p /var/run/sshd /var/backups/borg /var/lib/docker-borg/ssh \
    && mkdir /home/borg/.ssh \
    && chown borg.borg /var/backups/borg /home/borg/.ssh \
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

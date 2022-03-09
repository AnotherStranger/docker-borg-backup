FROM tgbyte/ubuntu:20.04

ARG BORG_VERSION

RUN set -x \
    && apt-get update -qq \
    && DEBIAN_FRONTEND=noninteractive apt-get install -qq -y \
        build-essential \
        libacl1 \
        libacl1-dev \
        liblz4-1 \
        liblz4-dev \
        libssl1.1 \
        libssl-dev \
        openssh-server \
        python3 \
        python3-pip \
        python3-pkgconfig \
        python3-setuptools \
        python3-setuptools-scm \
    && rm -f /etc/ssh/ssh_host_* \
    && pip3 install -v "borgbackup==${BORG_VERSION}" \
    && apt-get remove -y --purge \
        build-essential \
        libacl1-dev \
        liblz4-dev \
        libssl-dev \
    && apt-get autoremove -y --purge \
    && adduser --uid 500 --disabled-password --gecos "Borg Backup" --quiet borg \
    && mkdir -p /var/run/sshd /var/backups/borg /var/lib/docker-borg/ssh mkdir /home/borg/.ssh \
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

VOLUME ["/var/backups/borg", "/var/lib/docker-borg"]

ADD ./entrypoint.sh /

EXPOSE 22
CMD ["/entrypoint.sh"]

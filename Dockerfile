################################################################################
#                             PIN PACKAGE VERSIONS                             #
################################################################################
# renovate: datasource=repology depName=pypi/borgbackup versioning=python
ARG BORGBACKUP_VERSION="1.4.0"

# renovate: datasource=repology depName=alpine_3_21/openssh-server versioning=loose
ARG OPENSSH_VERSION="9.9_p1-r2"

# renovate: datasource=repology depName=alpine_3_21/sed versioning=loose
ARG SED_VERSION="4.9-r2"

# renovate: datasource=repology depName=alpine_3_21/bash versioning=loose
ARG BASH_VERSION="5.2.26-r0"

# renovate: datasource=repology depName=alpine_3_21/shadow versioning=loose
ARG SHADOW_VERSION="4.16.0-r1"

# renovate: datasource=repology depName=alpine_3_21/openssl versioning=loose
ARG OPENSSL_VERSION="3.3.3-r0"

# renovate: datasource=repology depName=alpine_3_21/pkgconf versioning=loose
ARG PKG_CONF_VERSION="2.3.0-r0"

# renovate: datasource=repology depName=alpine_3_21/build-base versioning=loose
ARG BUILD_BASE_VERSION="0.5-r3"

# renovate: datasource=repology depName=alpine_3_21/acl-dev versioning=loose
ARG ACL_VERSION="2.3.2-r1"

# renovate: datasource=repology depName=alpine_3_21/xxhash-dev versioning=loose
ARG XXHASH_VERSION="0.8.2-r2"

# renovate: datasource=repology depName=alpine_3_21/zstd versioning=loose
ARG ZSTD_VERSION="1.5.6-r2"

# renovate: datasource=repology depName=alpine_3_21/lz4 versioning=loose
ARG LZ4_VERSION="1.10.0-r0"

# renovate: datasource=repology depName=alpine_3_21/linux-headers versioning=loose
ARG LINUX_HEADERS_VERSION="6.6-r1"

FROM python:3.13.2-alpine3.21@sha256:323a717dc4a010fee21e3f1aac738ee10bb485de4e7593ce242b36ee48d6b352 AS base

################################################################################
#                    BUILD BORGBACKUP FROM SOURCE USING PIP                    #
################################################################################
FROM base AS builder

# Re-define needed ARGS
ARG BORGBACKUP_VERSION
ARG PKG_CONF_VERSION
ARG OPENSSL_VERSION
ARG ACL_VERSION
ARG XXHASH_VERSION
ARG ZSTD_VERSION
ARG LZ4_VERSION
ARG LINUX_HEADERS_VERSION
ARG BUILD_BASE_VERSION

RUN set -x && \
    apk add --no-cache \
        pkgconf="${PKG_CONF_VERSION}" \
        openssl-dev="${OPENSSL_VERSION}" \
        build-base="${BUILD_BASE_VERSION}" \
        acl-dev="${ACL_VERSION}" \
        zstd-dev="${ZSTD_VERSION}" \
        lz4-dev="${LZ4_VERSION}" \
        xxhash-dev="${XXHASH_VERSION}" \
        linux-headers="${LINUX_HEADERS_VERSION}" \
    && mkdir /wheel \
    && pip wheel borgbackup=="${BORGBACKUP_VERSION}" -w /wheel


################################################################################
#                INSTALL BUILT BORGBACKUP PACKAGE IN NEW STAGE                 #
################################################################################
FROM base AS runtime-image

# Re-define needed ARGS
ARG OPENSSH_VERSION
ARG SED_VERSION
ARG BASH_VERSION
ARG SHADOW_VERSION
ARG OPENSSL_VERSION
ARG XXHASH_VERSION
ARG ZSTD_VERSION
ARG LZ4_VERSION
ARG ACL_VERSION
ARG LINUX_HEADERS_VERSION

# Add author and github link to image metadata
LABEL org.opencontainers.image.authors="André Büsgen <andre.buesgen@posteo.de>"
LABEL org.opencontainers.image.source="https://github.com/AnotherStranger/docker-borg-backup"
LABEL org.opencontainers.image.url="https://github.com/AnotherStranger/docker-borg-backup"
LABEL org.opencontainers.image.documentation="https://github.com/AnotherStranger/docker-borg-backup"
LABEL org.opencontainers.image.description="A dockerized borgbackup server"
LABEL org.opencontainers.image.title="borg-server"

# Define supported Environment variables
ENV BORG_SERVE_ADDITIONAL_ARGS=""
ENV BORG_UID=""
ENV BORG_GID=""
ENV ENSURE_BACKUP_PERMISSIONS=true

RUN set -x && \
    apk add --no-cache \
        openssh-server="${OPENSSH_VERSION}" \
        sed="${SED_VERSION}" \
        bash="${BASH_VERSION}" \
        shadow="${SHADOW_VERSION}" \
        openssl="${OPENSSL_VERSION}" \
        xxhash="${XXHASH_VERSION}" xxhash-dev="${XXHASH_VERSION}" \
        acl="${ACL_VERSION}" acl-dev="${ACL_VERSION}" \
        zstd="${ZSTD_VERSION}" zstd-dev="${ZSTD_VERSION}" \
        lz4="${LZ4_VERSION}" lz4-dev="${LZ4_VERSION}" \
        linux-headers="${LINUX_HEADERS_VERSION}" \
    && adduser -D -u 500 borg borg \
    && mkdir -p /var/run/sshd /var/backups/borg /var/lib/docker-borg/ssh \
    && mkdir /home/borg/.ssh \
    && chown borg:borg /home/borg/.ssh \
    && chmod 700 /home/borg/.ssh

COPY --from=builder /wheel /wheel
RUN pip --no-cache-dir install /wheel/*.whl

# Configure SSH
RUN set -x \
    && sed -i \
        -e 's/^#PasswordAuthentication yes$/PasswordAuthentication no/g' \
        -e 's/^PermitRootLogin without-password$/PermitRootLogin no/g' \
        -e 's/^X11Forwarding yes$/X11Forwarding no/g' \
        -e 's/^#LogLevel .*$/LogLevel ERROR/g' \
        /etc/ssh/sshd_config \
&& echo "ClientAliveInterval 10" >> /etc/ssh/sshd_config \
&& echo "ClientAliveCountMax 30" >> /etc/ssh/sshd_config \
&& mkdir -p /var/lib/docker-borg/ssh \
&& mkdir -p /home/borg/backups

VOLUME ["/home/borg/backups/", "/var/lib/docker-borg", "/home/borg/.ssh/"]

COPY ./entrypoint.sh /

EXPOSE 22
CMD ["/entrypoint.sh"]

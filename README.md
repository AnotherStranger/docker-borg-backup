# docker-borg-backup

A dockerized Borg Backup server. For more information about Borg Backup, an excellent deduplicating backup, refer to: https://www.borgbackup.org/

## Usage

```
docker run -e BORG_AUTHORIZED_KEYS=<ssh_authorized_key> -e BORG_UID=<uid> -e BORG_GID=<gid> -v <borg_volume>:/var/backups/borg tgbyte/borg-backup
```

Alternatively, use the Docker orchestrator of your choice.

**Caution:** Do NOT forget to mount a volume into the Borg container. Otherwise your backups will vanish into thin air when you update the Borg container.

# docker-borg-backup

A dockerized Borg Backup server. For more information about Borg Backup, an
excellent de-duplicating backup, refer to: <https://www.borgbackup.org/>.

## Usage

**TL;DR**: pull the docker image from docker hub or ghcr, set the ssh-key
variable `BORG_AUTHORIZED_KEYS`, and mount volumes to `/home/borg/backups` and
`/var/lib/docker-borg`. Once the container is up and running you can start
creating backups with following Repo url:
`ssh://borg@<host or ip>:<port>/./backups/<your_repo>`.

### Docker run

```bash
docker run \
        -e BORG_AUTHORIZED_KEYS=<ssh_authorized_key> \
        -e BORG_UID=<uid> \
        -e BORG_GID=<gid> \
        -v <borg_volume>:/home/borg/backups horaceworblehat/borg-server
```

### Docker compose
<!-- markdownlint-disable -->
```yaml
version: '3'

services:
  borg:
    image: horaceworblehat/borg-server
    environment:
      # Specify you public ssh keys here. Separate keys by adding \n
      BORG_AUTHORIZED_KEYS: "key_one\nkey_two"
      BORG_SERVE_ADDITIONAL_ARGS: "--storage-quota 900G --append-only"
      BORG_UID: "1000" # optional: your user id (run id in bash)
      BORG_GID: "1000" # optional: your group id (run id in bash)
    volumes:
      - backup:/home/borg/backups # You can find your backups inside this volume
      - server_keys:/var/lib/docker-borg # This volume is used to persist the hosts ssh-keys across updates
      # - <path to authorized_keys file>:/home/borg/.ssh/authorized_keys <- Alternative to BORG_AUTHORIZED_KEYS
    ports:
      - "8022:22"

volumes:
  backup:
  server_keys:
```
<!-- markdownlint-enable -->

### Volumes

<!-- markdownlint-disable -->
| Path                              | Description                                                                              |
|-----------------------------------|------------------------------------------------------------------------------------------|
| `/home/borg/backups`              | All backups will be in this volume                                                       |
| `/var/lib/docker-borg`            | This volume persists the hosts ssh-keys across updates                                   |
| `/home/borg/.ssh/authorized_keys` | As an alternative to the variable `BORG_AUTHORIZED_KEYS` you can mount the file directly |
<!-- markdownlint-enable -->
### Environment variables

<!-- markdownlint-disable -->
| Variable                     | Description                                                                                                                    | Example                |
|------------------------------|--------------------------------------------------------------------------------------------------------------------------------|------------------------|
| `BORG_AUTHORIZED_KEYS`       | Public ssh keys for backups. Use either this Variable or the authorized_key file. May contain comment lines starting with `#`  | `<key-one>\n<key-two>` |
| `BORG_UID`                   | UID for the backup user.                                                                                                       | `1000`                 |
| `BORG_GID`                   | GID for the backup user.                                                                                                       | `1000`                 |
| `BORG_SERVE_ADDITIONAL_ARGS` | Additional CMD args to borg serve                                                                                              | `--append-only`        |
<!-- markdownlint-enable -->

### Important Notes

**Caution:** Do NOT forget to mount a volume as `/home/borg/backups/` to host
the backups. Otherwise, your backups will vanish into thin air when you update
the Borg container.

To persist the container's SSH host keys across container updates, mount a
volume to `/var/lib/docker-borg`.

## Supported Architectures

This image is available for the `linux/386`, `linux/amd64`, `linux/arm/v7`,
`linux/arm64/v8`, `linux/ppc64le`, and `linux/s390x` architectures.

## Contributors

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->

<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->

## License

The files contained in this Git repository are licensed under the following
license. This license explicitly does not cover the Borg Backup and Ubuntu
software packaged when running the Docker build. For these components, separate
licenses apply that you can find at:

* <https://borgbackup.readthedocs.io/en/stable/authors.html#license>
* <https://ubuntu.com/licensing>

Copyright 2023 André Büsgen

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

[http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

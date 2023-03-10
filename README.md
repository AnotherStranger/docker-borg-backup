# docker-borg-backup

A dockerized Borg Backup server. For more information about Borg Backup, an
excellent de-duplicating backup, refer to: <https://www.borgbackup.org/>

## Usage

```bash
docker run \
        -e BORG_AUTHORIZED_KEYS=<ssh_authorized_key> \
        -e BORG_UID=<uid> \
        -e BORG_GID=<gid> \
        -v <borg_volume>:/var/backups/borg horaceworblehat/borg-server
```

Alternatively, use the Docker orchestrator of your choice.

**Caution:** Do NOT forget to mount a volume as `/home/borg/backups/` to host
the backups. Otherwise your backups will vanish into thin air when you update
the Borg container.

To persist the container's SSH host keys across container updates, mount a
volume to `/var/lib/docker-borg`.

## Supported Architectures

This image is available for the `amd64` and `arm64` architectures.

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

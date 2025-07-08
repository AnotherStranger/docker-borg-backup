# docker-borg-backup
<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->
[![All Contributors](https://img.shields.io/badge/all_contributors-6-orange.svg?style=flat-square)](#contributors-)
<!-- ALL-CONTRIBUTORS-BADGE:END -->

A dockerized Borg Backup server. For more information about Borg Backup, an
excellent de-duplicating backup, refer to: <https://www.borgbackup.org/>.
If you find something missing for your use case feel free to open a PR or Issue!

This Container is based on [https://github.com/tgbyte/docker-borg-backup](https://github.com/tgbyte/docker-borg-backup).
This Repo adds the following features/changes:

- Support for mounting an authorized_keys file
- Restricts ssh to the `borg serve` command by default
  - Additional arguments can be set using an environment variable
- Automatic builds and releases following [semantic versioning](https://semver.org/)
  using [semantic-release](https://semantic-release.gitbook.io/semantic-release)
- All dependencies are pinned and updated automatically using [renovate](https://docs.renovatebot.com/)
- The container is built for more [architectures](#supported-architectures)

## Usage

**TL;DR**: pull the docker image from docker hub or ghcr, set the ssh-key
variable `BORG_AUTHORIZED_KEYS`, and mount volumes to `/home/borg/backups` and
`/var/lib/docker-borg`. Once the container is up and running you can start
creating backups with following Repo url:
`ssh://borg@<host or ip>:<port>/./backups/<your_repo>`.

### TrueNas Scale

If you're running TrueNas Scale you can use this container via the chart
provided by [TrueCharts](https://truecharts.org/).
You can find the documentation here: [https://truecharts.org/charts/stable/borg-server/](https://truecharts.org/charts/stable/borg-server/).

It seems to be a quick and easy solution for running this container.

**Disclaimer:** I did not write the chart, and I also do not have access to a
TrueNas installation. Therefore, I also have no possibility of testing the
integration myself.

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
      ENSURE_BACKUP_PERMISSIONS: true # optional (default: true) if set to false chown -R borg:borg on your backups will be skipped
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
| `ENSURE_BACKUP_PERMISSIONS` | If set to false chown -R borg:borg on your backups will be skipped. Default: true.                                             | `false`                |
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
<table>
  <tbody>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://www.tgbyte.de/"><img src="https://avatars.githubusercontent.com/u/174129?v=4?s=100" width="100px;" alt="Thilo-Alexander Ginkel"/><br /><sub><b>Thilo-Alexander Ginkel</b></sub></a><br /><a href="https://github.com/AnotherStranger/docker-borg-backup/commits?author=ginkel" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/AnotherStranger"><img src="https://avatars.githubusercontent.com/u/6563442?v=4?s=100" width="100px;" alt="AnotherStranger"/><br /><sub><b>AnotherStranger</b></sub></a><br /><a href="https://github.com/AnotherStranger/docker-borg-backup/commits?author=AnotherStranger" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/Spice-King"><img src="https://avatars.githubusercontent.com/u/590498?v=4?s=100" width="100px;" alt="Kyle Filz"/><br /><sub><b>Kyle Filz</b></sub></a><br /><a href="https://github.com/AnotherStranger/docker-borg-backup/commits?author=Spice-King" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/Ph3n1x"><img src="https://avatars.githubusercontent.com/u/8397249?v=4?s=100" width="100px;" alt="Ph3n1x"/><br /><sub><b>Ph3n1x</b></sub></a><br /><a href="https://github.com/AnotherStranger/docker-borg-backup/commits?author=Ph3n1x" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/nj"><img src="https://avatars.githubusercontent.com/u/317552?v=4?s=100" width="100px;" alt="Nikolaj Jørgensen"/><br /><sub><b>Nikolaj Jørgensen</b></sub></a><br /><a href="https://github.com/AnotherStranger/docker-borg-backup/commits?author=nj" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="http://www.mistergoodcat.com"><img src="https://avatars.githubusercontent.com/u/7507932?v=4?s=100" width="100px;" alt="Peter Kuhn"/><br /><sub><b>Peter Kuhn</b></sub></a><br /><a href="https://github.com/AnotherStranger/docker-borg-backup/commits?author=MisterGoodcat" title="Documentation">📖</a></td>
    </tr>
  </tbody>
  <tfoot>
    <tr>
      <td align="center" size="13px" colspan="7">
        <img src="https://raw.githubusercontent.com/all-contributors/all-contributors-cli/1b8533af435da9854653492b1327a23a4dbd0a10/assets/logo-small.svg">
          <a href="https://all-contributors.js.org/docs/en/bot/usage">Add your contributions</a>
        </img>
      </td>
    </tr>
  </tfoot>
</table>

<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->

## License

The files contained in this Git repository are licensed under the following
license. This license explicitly does not cover the Borg Backup and Ubuntu
software packaged when running the Docker build. For these components, separate
licenses apply that you can find at:

- <https://borgbackup.readthedocs.io/en/stable/authors.html#license>
- <https://ubuntu.com/licensing>

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

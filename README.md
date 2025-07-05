# docker-borg-backup
<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->
[![All Contributors](https://img.shields.io/badge/all_contributors-5-orange.svg?style=flat-square)](#contributors)
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

## TrueNAS Community Edition

**TL;DR**: The Docker image can be set up relatively easily as custom application in TrueNAS. To learn more about the concept and configuration of custom apps, please refer to the official documentation here: [https://apps.truenas.com/managing-apps/](https://apps.truenas.com/managing-apps/). The idiomatic way of configuring custom apps is not particularly well-suited for the sensitive nature of a Borg server however, so the following describes a few tweaks to improve the setup.

### Critical Details of the Default App Configuration

There is two moving parts in the TrueNAS apps concept that should be challenged:

- TrueNAS offers a dataset preset for `Apps` usage. This is problematic because it automatically configures extensive ACLs for the `builtin_users` group, which (despite the misleading name) automatically contains all custom created user accounts. Consequently, this would grant write permissions to the raw Borg repository files to all users of the system, something that is highly undesired.
- TrueNAS uses a single user account that is intended to be used by apps (UID 568), either to start the container with, or for individual processes. In case of a privilege escalation in _any_ of the configured app containers, an attacker could potentially access all of the raw Borg data. Using that built-in user account hence is not an ideal option.

### Prerequisites

1. Create a separate user named `borg` and take note of the generated `UID` and `GID`. Recommended configuration details:

    - Lock the user account
    - Do not create a home directory
    - Do not configure shell/SSH/SMB
    - Do not select any sudo features

2. Create the two required datasets for the backups and server keys. For these:

    - Do _not_ use the `Apps` preset, but use `Generic` instead
    - Change the owner to the `borg` user and group
    - Make sure to remove all default permissions preselected for `other`

### Create the Custom App

Set the following configuration options and adjust at your discretion.

<!-- markdownlint-disable -->
| Section                 | Option                                            | Value                                                                                                                                                        |
|-------------------------|---------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Application             | Application Name                                  | For example, `borg`                                                                                                                                          |
| Image Configuration     | Repository                                        | `horaceworblehat/borg-server`                                                                                                                                |
|                         | Tag                                               | `latest`                                                                                                                                                     |
| Container Configuration | Environment Variable `BORG_AUTHORIZED_KEYS`       | Your public SSH key                                                                                                                                          |
|                         | Environment Variable `BORG_UID`                   | The `UID` of the dedicated `borg` user                                                                                                                       |
|                         | Environment Variable `BORG_GID`                   | The `GID` of the dedicated `borg` user                                                                                                                       |
|                         | Environment variable `BORG_SERVE_ADDITIONAL_ARGS` | Additional args for the Borg server, as documented, for example `--append-only`                                                                              |
| Network Configuration   | Ports                                             | Unless you bind the app to a dedicated IP address (e.g. VLAN), use a host port other than `22` to avoid conflicts with the TrueNAS host SSH. Example: `8022` |
| Storage Configuration   | Storage 1: Bind `/home/borg/backups`              | Use the host path you created before, e.g. `mnt/data/backups/borg`                                                                                           |
|                         | Storage 2: Bind `/var/lib/docker-borg`            | Use the host path you created before, e.g. `mnt/apps/borg/data`                                                                                              |
<!-- markdownlint-enable -->

### Optional: Mount `authorized_keys`

If you intend to mount the `authorized_keys` instead of providing the value through the environment variable, note that you need to bind _the parent directory_ to the host instead. The storage configuration should look like:

- Mount path: `/home/borg/.ssh`
- Host path: `/mnt/your/desired/path`

As with the other host paths described here, create the dataset as non-ACL, owned by the dedicated `borg` user. Make sure to set the permissions correctly for what SSH expects for both the dataset as well as your `authorized_keys` file.

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

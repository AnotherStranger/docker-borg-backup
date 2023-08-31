## [2.0.0-rc.1](https://github.com/AnotherStranger/docker-borg-backup/compare/v1.10.4...v2.0.0-rc.1) (2023-08-31)


### ⚠ BREAKING CHANGES

* **borg:** While this is a server only image I will mark this release as BREAKING CHANGE. See  https://github.com/borgbackup/borg/blob/1.2.5-cvedocs/docs/changes.rst#pre-125-archives-spoofing-vulnerability-cve-2023-36811 for a HOWTO upgrade.

### Bug Fixes

* **borg:** :arrow_up: Update borg to version 1.2.5. See Notes! ([6a50042](https://github.com/AnotherStranger/docker-borg-backup/commit/6a500420d282f1f957da2a5187f15f6236a15a33))

## [1.10.4](https://github.com/AnotherStranger/docker-borg-backup/compare/v1.10.3...v1.10.4) (2023-08-09)


### Build System

* **release:** 1.10.4-rc.1 ([efae856](https://github.com/AnotherStranger/docker-borg-backup/commit/efae85620ae54161c151d7c7f56a66cd486cfab3))


### Code Refactoring

* **docker:** :arrow_up: upgrade docker image dependencies ([5ac6c00](https://github.com/AnotherStranger/docker-borg-backup/commit/5ac6c00d1284f52f43d1900f62eb6fb5321f07bf))

## [1.10.4-rc.1](https://github.com/AnotherStranger/docker-borg-backup/compare/v1.10.3...v1.10.4-rc.1) (2023-08-09)


### Code Refactoring

* **docker:** :arrow_up: upgrade docker image dependencies ([5ac6c00](https://github.com/AnotherStranger/docker-borg-backup/commit/5ac6c00d1284f52f43d1900f62eb6fb5321f07bf))

## [1.10.3](https://github.com/AnotherStranger/docker-borg-backup/compare/v1.10.2...v1.10.3) (2023-06-19)


### Build System

* **release:** 1.10.3-rc.1 ([df3e4f6](https://github.com/AnotherStranger/docker-borg-backup/commit/df3e4f6d8d7557f85795fa80248690b3fe855bf4))


### Code Refactoring

* **docker:** :arrow_up: update shadow version ([5047252](https://github.com/AnotherStranger/docker-borg-backup/commit/504725267eeeb7f2aec5c5e419cec8a83e05f991))

## [1.10.3-rc.1](https://github.com/AnotherStranger/docker-borg-backup/compare/v1.10.2...v1.10.3-rc.1) (2023-06-19)


### Code Refactoring

* **docker:** :arrow_up: update shadow version ([5047252](https://github.com/AnotherStranger/docker-borg-backup/commit/504725267eeeb7f2aec5c5e419cec8a83e05f991))

## [1.10.2](https://github.com/AnotherStranger/docker-borg-backup/compare/v1.10.1...v1.10.2) (2023-06-14)


### Code Refactoring

* :recycle: add presetConfig for release-notes-generator ([cf96bec](https://github.com/AnotherStranger/docker-borg-backup/commit/cf96bece002266fd842f94ee167ee12789c65445))


### Build System

* **release:** 1.10.1-rc.3 ([710a926](https://github.com/AnotherStranger/docker-borg-backup/commit/710a926a89cfef2d787fbfefc7c60094ececa7e8))
* **release:** 1.10.2-rc.1 ([70dc96a](https://github.com/AnotherStranger/docker-borg-backup/commit/70dc96a77a1f5738bee53cc43fb9e52e1af2a642))
* Merge branch 'dev' of https://github.com/AnotherStranger/docker-borg-backup into dev ([6ff9cba](https://github.com/AnotherStranger/docker-borg-backup/commit/6ff9cba7a7dbbe3fbd39a6f36f3985a965f2d1b4))
* Merge branch 'main' into dev ([50b1442](https://github.com/AnotherStranger/docker-borg-backup/commit/50b1442a641f4945091fbce43f8876a84f36a857))

## [1.10.2-rc.1](https://github.com/AnotherStranger/docker-borg-backup/compare/v1.10.1...v1.10.2-rc.1) (2023-06-12)


### Code Refactoring

* :recycle: add presetConfig for release-notes-generator ([cf96bec](https://github.com/AnotherStranger/docker-borg-backup/commit/cf96bece002266fd842f94ee167ee12789c65445))


### Build System

* **release:** 1.10.1-rc.3 ([710a926](https://github.com/AnotherStranger/docker-borg-backup/commit/710a926a89cfef2d787fbfefc7c60094ececa7e8))
* Merge branch 'dev' of https://github.com/AnotherStranger/docker-borg-backup into dev ([6ff9cba](https://github.com/AnotherStranger/docker-borg-backup/commit/6ff9cba7a7dbbe3fbd39a6f36f3985a965f2d1b4))
* Merge branch 'main' into dev ([50b1442](https://github.com/AnotherStranger/docker-borg-backup/commit/50b1442a641f4945091fbce43f8876a84f36a857))

## [1.10.2-rc.1](https://github.com/AnotherStranger/docker-borg-backup/compare/v1.10.1-rc.2...v1.10.1-rc.3) (2023-06-12)


### Code Refactoring

* :recycle: add presetConfig for release-notes-generator ([cf96bec](https://github.com/AnotherStranger/docker-borg-backup/commit/cf96bece002266fd842f94ee167ee12789c65445))


### Build System

* Merge branch 'dev' of https://github.com/AnotherStranger/docker-borg-backup into dev ([6ff9cba](https://github.com/AnotherStranger/docker-borg-backup/commit/6ff9cba7a7dbbe3fbd39a6f36f3985a965f2d1b4))

## [1.10.1](https://github.com/AnotherStranger/docker-borg-backup/compare/v1.10.0...v1.10.1) (2023-06-12)


### Bug Fixes

* :bug: add missing package in release ([9af1937](https://github.com/AnotherStranger/docker-borg-backup/commit/9af1937e3af250dcd2f38fc7b3732f7d399f4f67))
* **ci:** :bug: Disable build cache to force base image pull ([672e4f4](https://github.com/AnotherStranger/docker-borg-backup/commit/672e4f49b1845d4e56e1f4314d1a2315026f6ede))


### Reverts

* Revert "fix(ci): :bug: Disable build cache to force base image pull" ([6a6f0bf](https://github.com/AnotherStranger/docker-borg-backup/commit/6a6f0bf9ada405f3b8b09f7494144190d7e4160f))

## [1.10.1-rc.2](https://github.com/AnotherStranger/docker-borg-backup/compare/v1.10.1-rc.1...v1.10.1-rc.2) (2023-06-12)


### Bug Fixes

* :bug: add missing package in release ([9af1937](https://github.com/AnotherStranger/docker-borg-backup/commit/9af1937e3af250dcd2f38fc7b3732f7d399f4f67))

## [1.10.1-rc.1](https://github.com/AnotherStranger/docker-borg-backup/compare/v1.10.0...v1.10.1-rc.1) (2023-06-12)


### Bug Fixes

* **ci:** :bug: Disable build cache to force base image pull ([672e4f4](https://github.com/AnotherStranger/docker-borg-backup/commit/672e4f49b1845d4e56e1f4314d1a2315026f6ede))


### Reverts

* Revert "fix(ci): :bug: Disable build cache to force base image pull" ([6a6f0bf](https://github.com/AnotherStranger/docker-borg-backup/commit/6a6f0bf9ada405f3b8b09f7494144190d7e4160f))

# [1.10.0](https://github.com/AnotherStranger/docker-borg-backup/compare/v1.9.3...v1.10.0) (2023-05-17)


### Features

* **docker:** :arrow_up: Update python baseimage to python 3.11 ([936dd6f](https://github.com/AnotherStranger/docker-borg-backup/commit/936dd6fe55234456814f3b73773b13db53e64122))

# [1.10.0-rc.1](https://github.com/AnotherStranger/docker-borg-backup/compare/v1.9.3...v1.10.0-rc.1) (2023-05-16)


### Features

* **docker:** :arrow_up: Update python baseimage to python 3.11 ([936dd6f](https://github.com/AnotherStranger/docker-borg-backup/commit/936dd6fe55234456814f3b73773b13db53e64122))

## [1.9.3](https://github.com/AnotherStranger/docker-borg-backup/compare/v1.9.2...v1.9.3) (2023-05-05)

## [1.9.3-rc.1](https://github.com/AnotherStranger/docker-borg-backup/compare/v1.9.2...v1.9.3-rc.1) (2023-05-03)

## [1.9.2](https://github.com/AnotherStranger/docker-borg-backup/compare/v1.9.1...v1.9.2) (2023-04-11)


### Bug Fixes

* **ci:** :bug: list refactorings in changelog ([de202e6](https://github.com/AnotherStranger/docker-borg-backup/commit/de202e68d13e96410257a5a39aedc8e590ecf50f))

## [1.9.2-rc.1](https://github.com/AnotherStranger/docker-borg-backup/compare/v1.9.1...v1.9.2-rc.1) (2023-04-11)


### Bug Fixes

* **ci:** :bug: list refactorings in changelog ([de202e6](https://github.com/AnotherStranger/docker-borg-backup/commit/de202e68d13e96410257a5a39aedc8e590ecf50f))

## [1.9.1](https://github.com/AnotherStranger/docker-borg-backup/compare/v1.9.0...v1.9.1) (2023-03-31)


### Bug Fixes

* **ci:** :adhesive_bandage: ignore generated CHANGElOG.md in pre-commit ([e548e13](https://github.com/AnotherStranger/docker-borg-backup/commit/e548e13eb590aefc356306bacbc574ba2aa29c04))
* **ci:** :adhesive_bandage: remove duplicate definition of releasenotes-generator ([dc0ada8](https://github.com/AnotherStranger/docker-borg-backup/commit/dc0ada894e808a17c61661444abd4b3f30461a38))


## [1.9.1-rc.1](https://github.com/AnotherStranger/docker-borg-backup/compare/v1.9.0...v1.9.1-rc.1) (2023-03-31)


### Bug Fixes

* **ci:** :adhesive_bandage: ignore generated CHANGElOG.md in pre-commit ([e548e13](https://github.com/AnotherStranger/docker-borg-backup/commit/e548e13eb590aefc356306bacbc574ba2aa29c04))
* **ci:** :adhesive_bandage: remove duplicate definition of releasenotes-generator ([dc0ada8](https://github.com/AnotherStranger/docker-borg-backup/commit/dc0ada894e808a17c61661444abd4b3f30461a38))

# [1.9.0-rc.2](https://github.com/AnotherStranger/docker-borg-backup/compare/v1.9.0-rc.1...v1.9.0-rc.2) (2023-03-31)

### Bug Fixes

* **ci:** :adhesive_bandage: ignore generated CHANGElOG.md in pre-commit ([e548e13](https://github.com/AnotherStranger/docker-borg-backup/commit/e548e13eb590aefc356306bacbc574ba2aa29c04))
* **ci:** :adhesive_bandage: remove duplicate definition of releasenotes-generator ([dc0ada8](https://github.com/AnotherStranger/docker-borg-backup/commit/dc0ada894e808a17c61661444abd4b3f30461a38))

# [1.9.0](https://github.com/AnotherStranger/docker-borg-backup/compare/v1.8.1...v1.9.0) (2023-03-31)


### Features

* **docs:** :memo: add changelog.md generation to repository ([6fce777](https://github.com/AnotherStranger/docker-borg-backup/commit/6fce777c4ac38383102913ff33038f57cee3c8e7))



# [1.9.0](https://github.com/AnotherStranger/docker-borg-backup/compare/v1.8.1...v1.9.0) (2023-03-31)


### Features

* **docs:** :memo: add changelog.md generation to repository ([6fce777](https://github.com/AnotherStranger/docker-borg-backup/commit/6fce777c4ac38383102913ff33038f57cee3c8e7))


# [1.9.0-rc.1](https://github.com/AnotherStranger/docker-borg-backup/compare/v1.8.1...v1.9.0-rc.1) (2023-03-31)

### Features

* **docs:** :memo: add changelog.md generation to repository ([6fce777](https://github.com/AnotherStranger/docker-borg-backup/commit/6fce777c4ac38383102913ff33038f57cee3c8e7))

# [1.9.0-rc.1](https://github.com/AnotherStranger/docker-borg-backup/compare/v1.8.1...v1.9.0-rc.1) (2023-03-31)

### Features

* **docs:** :memo: add changelog.md generation to repository ([6fce777](https://github.com/AnotherStranger/docker-borg-backup/commit/6fce777c4ac38383102913ff33038f57cee3c8e7))

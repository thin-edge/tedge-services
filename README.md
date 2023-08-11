# tedge-services

thin-edge.io service file definitions for the following init systems:

* sysvinit
* openrc
* runit
* s6-overlay
* supervisord

This is a community driven repository where users are encouraged to create PRs to add support for any additional init system, or make changes to any of the existing definitions.

## Installation

The service definitions provided in the project are published to the [Community Repository](https://cloudsmith.io/~thinedge/repos/community/groups/) for easy installation.


The service definitions packages are there to compliment the existing thin-edge.io components by extending support beyond the default systemd service definitions.


The init system specific packages included the following contents:

* service definitions for all thin-edge.io components (one package per init system type)
* `/usr/bin/tedgectl` script used to abstract the calls to the init system (e.g. start/stop/restart/enable/disable services)
* `/etc/tedge/system.toml` configuration file used by thin-edge.io to abstract interactions with the init system

If you have not already installed thin-edge.io on your device, please follow the [installation guide](https://thin-edge.github.io/thin-edge.io/install/) from the official thin-edge.io documentation.

### Pre-requisites

You must have already installed thin-edge.io and its components prior to installing the service definitions. If you don't so this, then you will have to manually enable and start the thin-edge.io services.

### Debian/Ubuntu

**Overview of packages**

|Package|Link|
|--|--|
|tedge-sysvinit|[![Latest version of 'tedge-sysvinit' @ Cloudsmith](https://api-prd.cloudsmith.io/v1/badges/version/thinedge/community/deb/tedge-sysvinit/latest/a=all;d=any-distro%252Fany-version;t=binary/?render=true&show_latest=true)](https://cloudsmith.io/~thinedge/repos/community/packages/detail/deb/tedge-sysvinit/latest/a=all;d=any-distro%252Fany-version;t=binary/)|
|tedge-openrc|[![Latest version of 'tedge-openrc' @ Cloudsmith](https://api-prd.cloudsmith.io/v1/badges/version/thinedge/community/deb/tedge-openrc/latest/a=all;d=any-distro%252Fany-version;t=binary/?render=true&show_latest=true)](https://cloudsmith.io/~thinedge/repos/community/packages/detail/deb/tedge-openrc/latest/a=all;d=any-distro%252Fany-version;t=binary/)|
|tedge-runit|[![Latest version of 'tedge-runit' @ Cloudsmith](https://api-prd.cloudsmith.io/v1/badges/version/thinedge/community/deb/tedge-runit/latest/a=all;d=any-distro%252Fany-version;t=binary/?render=true&show_latest=true)](https://cloudsmith.io/~thinedge/repos/community/packages/detail/deb/tedge-runit/latest/a=all;d=any-distro%252Fany-version;t=binary/)|
|tedge-s6overlay|[![Latest version of 'tedge-s6overlay' @ Cloudsmith](https://api-prd.cloudsmith.io/v1/badges/version/thinedge/community/deb/tedge-s6overlay/latest/a=all;d=any-distro%252Fany-version;t=binary/?render=true&show_latest=true)](https://cloudsmith.io/~thinedge/repos/community/packages/detail/deb/tedge-s6overlay/latest/a=all;d=any-distro%252Fany-version;t=binary/)|
|tedge-supervisord|[![Latest version of 'tedge-supervisord' @ Cloudsmith](https://api-prd.cloudsmith.io/v1/badges/version/thinedge/community/deb/tedge-supervisord/latest/a=all;d=any-distro%252Fany-version;t=binary/?render=true&show_latest=true)](https://cloudsmith.io/~thinedge/repos/community/packages/detail/deb/tedge-supervisord/latest/a=all;d=any-distro%252Fany-version;t=binary/)|


**Install instructions**

Setup the repository using:

```sh
curl -1sLf 'https://dl.cloudsmith.io/public/thinedge/community/setup.deb.sh' | sudo bash
```

Then install your preferred init system service definition files:

```sh
# sysvinit
sudo apt-get install tedge-sysvinit

# openrc
sudo apt-get install tedge-openrc

# runit
sudo apt-get install tedge-runit

# s6-overlay (docker friendly init system)
sudo apt-get install tedge-s6overlay

# supervisord
sudo apt-get install tedge-supervisord
```

### RHEL/Fedora/RockyLinux

**Overview of packages**

|Package|Link|
|--|--|
|tedge-sysvinit|[![Latest version of 'tedge-sysvinit' @ Cloudsmith](https://api-prd.cloudsmith.io/v1/badges/version/thinedge/community/rpm/tedge-sysvinit/latest/a=noarch;d=any-distro%252Fany-version;t=binary/?render=true&show_latest=true)](https://cloudsmith.io/~thinedge/repos/community/packages/detail/rpm/tedge-sysvinit/latest/a=noarch;d=any-distro%252Fany-version;t=binary/)|
|tedge-openrc|[![Latest version of 'tedge-openrc' @ Cloudsmith](https://api-prd.cloudsmith.io/v1/badges/version/thinedge/community/rpm/tedge-openrc/latest/a=noarch;d=any-distro%252Fany-version;t=binary/?render=true&show_latest=true)](https://cloudsmith.io/~thinedge/repos/community/packages/detail/rpm/tedge-openrc/latest/a=noarch;d=any-distro%252Fany-version;t=binary/)|
|tedge-runit|[![Latest version of 'tedge-runit' @ Cloudsmith](https://api-prd.cloudsmith.io/v1/badges/version/thinedge/community/rpm/tedge-runit/latest/a=noarch;d=any-distro%252Fany-version;t=binary/?render=true&show_latest=true)](https://cloudsmith.io/~thinedge/repos/community/packages/detail/rpm/tedge-runit/latest/a=noarch;d=any-distro%252Fany-version;t=binary/)|
|tedge-s6overlay|[![Latest version of 'tedge-s6overlay' @ Cloudsmith](https://api-prd.cloudsmith.io/v1/badges/version/thinedge/community/rpm/tedge-s6overlay/latest/a=noarch;d=any-distro%252Fany-version;t=binary/?render=true&show_latest=true)](https://cloudsmith.io/~thinedge/repos/community/packages/detail/rpm/tedge-s6overlay/latest/a=noarch;d=any-distro%252Fany-version;t=binary/)|
|tedge-supervisord|[![Latest version of 'tedge-supervisord' @ Cloudsmith](https://api-prd.cloudsmith.io/v1/badges/version/thinedge/community/rpm/tedge-supervisord/latest/a=noarch;d=any-distro%252Fany-version;t=binary/?render=true&show_latest=true)](https://cloudsmith.io/~thinedge/repos/community/packages/detail/rpm/tedge-supervisord/latest/a=noarch;d=any-distro%252Fany-version;t=binary/)|

Setup the repository using:

```sh
curl -1sLf 'https://dl.cloudsmith.io/public/thinedge/community/setup.rpm.sh' | sudo bash
```

Then install your preferred init system service definition files:

```sh
# sysvinit
sudo dnf install tedge-sysvinit

# openrc
sudo dnf install tedge-openrc

# runit
sudo dnf install tedge-runit

# s6-overlay (docker friendly init system)
sudo dnf install tedge-s6overlay

# supervisord
sudo dnf install tedge-supervisord
```

### Alpine Linux

**Overview of packages**

|Package|Link|
|--|--|
|tedge-sysvinit|[![Latest version of 'tedge-sysvinit' @ Cloudsmith](https://api-prd.cloudsmith.io/v1/badges/version/thinedge/community/alpine/tedge-sysvinit/latest/a=noarch;d=alpine%252Fany-version/?render=true&show_latest=true)](https://cloudsmith.io/~thinedge/repos/community/packages/detail/alpine/tedge-sysvinit/latest/a=noarch;d=alpine%252Fany-version/)
|tedge-openrc|[![Latest version of 'tedge-openrc' @ Cloudsmith](https://api-prd.cloudsmith.io/v1/badges/version/thinedge/community/alpine/tedge-openrc/latest/a=noarch;d=alpine%252Fany-version/?render=true&show_latest=true)](https://cloudsmith.io/~thinedge/repos/community/packages/detail/alpine/tedge-openrc/latest/a=noarch;d=alpine%252Fany-version/)
|tedge-runit|[![Latest version of 'tedge-runit' @ Cloudsmith](https://api-prd.cloudsmith.io/v1/badges/version/thinedge/community/alpine/tedge-runit/latest/a=noarch;d=alpine%252Fany-version/?render=true&show_latest=true)](https://cloudsmith.io/~thinedge/repos/community/packages/detail/alpine/tedge-runit/latest/a=noarch;d=alpine%252Fany-version/)
|tedge-s6overlay|[![Latest version of 'tedge-s6overlay' @ Cloudsmith](https://api-prd.cloudsmith.io/v1/badges/version/thinedge/community/alpine/tedge-s6overlay/latest/a=noarch;d=alpine%252Fany-version/?render=true&show_latest=true)](https://cloudsmith.io/~thinedge/repos/community/packages/detail/alpine/tedge-s6overlay/latest/a=noarch;d=alpine%252Fany-version/)|
|tedge-supervisord|[![Latest version of 'tedge-supervisord' @ Cloudsmith](https://api-prd.cloudsmith.io/v1/badges/version/thinedge/community/alpine/tedge-supervisord/latest/a=noarch;d=alpine%252Fany-version/?render=true&show_latest=true)](https://cloudsmith.io/~thinedge/repos/community/packages/detail/alpine/tedge-supervisord/latest/a=noarch;d=alpine%252Fany-version/)|


**Install instructions**

Setup the repository using:

```sh
curl -1sLf 'https://dl.cloudsmith.io/public/thinedge/community/setup.alpine.sh' | sudo bash
```

Then install your preferred init system service definition files:

```sh
# sysvinit
sudo apk add tedge-sysvinit

# openrc
sudo apk add tedge-openrc

# runit
sudo apk add tedge-runit

# s6-overlay (docker friendly init system)
sudo apk add tedge-s6overlay

# supervisord
sudo apk add tedge-supervisord
```

### Other distributions / tarball

The service definitions are also available via a tarball which can be manually installed using the following steps:

1. Download and extract the tarball for your preferred init system

    **SysVinit**

    ```sh
    curl -O 'https://dl.cloudsmith.io/public/thinedge/community/raw/names/tedge-sysvinit/versions/latest/tedge-sysvinit.tar.gz'
    sudo tar xzvf tedge-sysvinit.tar.gz -C /
    ```

    **SysVinit (yocto)**

    ```sh
    curl -O 'https://dl.cloudsmith.io/public/thinedge/community/raw/names/tedge-sysvinit-yocto/versions/latest/tedge-sysvinit-yocto.tar.gz'
    sudo tar xzvf tedge-sysvinit-yocto.tar.gz -C /
    ```

    **OpenRC**

    ```sh
    curl -O 'https://dl.cloudsmith.io/public/thinedge/community/raw/names/tedge-openrc/versions/latest/tedge-openrc.tar.gz'
    sudo tar xzvf tedge-openrc.tar.gz -C /
    ```

    **runit**

    ```sh
    curl -O 'https://dl.cloudsmith.io/public/thinedge/community/raw/names/tedge-runit/versions/latest/tedge-runit.tar.gz'
    sudo tar xzvf tedge-runit.tar.gz -C /
    ```

    **s6-overlay**

    ```sh
    curl -O 'https://dl.cloudsmith.io/public/thinedge/community/raw/names/tedge-s6overlay/versions/latest/tedge-s6overlay.tar.gz'
    sudo tar xzvf tedge-s6overlay.tar.gz -C /
    ```

    **supervisord**

    ```sh
    curl -O 'https://dl.cloudsmith.io/public/thinedge/community/raw/names/tedge-supervisord/versions/latest/tedge-supervisord.tar.gz'
    sudo tar xzvf tedge-supervisord.tar.gz -C /
    ```

2. Enable/start the services using the generic `tedgectl` script which in included in the tarball

    For example if you want to enable all of the services then use:

    ```sh
    tedgectl enable tedge-mapper-c8y
    tedgectl start tedge-mapper-c8y

    tedgectl enable tedge-mapper-az
    tedgectl start tedge-mapper-az

    tedgectl enable tedge-mapper-aws
    tedgectl start tedge-mapper-aws

    tedgectl enable tedge-mapper-collectd
    tedgectl start tedge-mapper-collectd

    tedgectl enable tedge-agent
    tedgectl start tedge-agent

    tedgectl enable c8y-configuration-plugin
    tedgectl start c8y-configuration-plugin

    tedgectl enable c8y-log-plugin
    tedgectl start c8y-log-plugin

    tedgectl enable c8y-firmware-plugin
    tedgectl start c8y-firmware-plugin
    ```

    **Notes**

    Some of the service will exit if you have not already setup thin-edge. Check out the [Getting Started](https://thin-edge.github.io/thin-edge.io/start/getting-started/) guide for details on how to configure and use thin-edge.io.

## Developers

This section details how to build the linux packages used to deliver the service files.

### Pre-requisites

You need to have [nfpm](https://nfpm.goreleaser.com/install/) installed first before running the build tasks.

### Build

1. Build the packages (including generating service files from the templates)

    ```sh
    just build
    ```

2. Start test containers (one per init system)

    ```sh
    just start
    ```

3. Start a console and test the functions

    **Start console inside one of the containers**

    ```sh
    docker compose exec tedge-sysvinit sh
    ```

    **Check service**

    ```sh
    # Start service
    tedgectl start tedge-agent

    # Check it is running
    pgrep -fa tedge-agent

    # Check log file
    tail -f /var/log/tedge-agent.log

    # Stop service
    tedgectl stop tedge-agent

    # Check if service is stopped
    pgrep -fa tedge-agent
    ```

## Init Systems

`tedgectl` is provided in the project to help interact with each of the init systems using the same interface. Each of the init systems can be interacted with using the following commands.

### Start service

```sh
tedgectl start <name>
```

### Stop service

```sh
tedgectl stop <name>
```

### Enable service

```sh
tedgectl enable <name>
```

### Disable service

```sh
tedgectl disable <name>
```


## sysvinit

### Get logs

```sh
tail -f /var/log/<name>.log
```

## openrc

### Get logs

```sh
tail -f /var/log/<name>.log
```

## s6-overlay

### Get logs

```sh
TODO
```

## Acknowledgements

[![Hosted By: Cloudsmith](https://img.shields.io/badge/OSS%20hosting%20by-cloudsmith-blue?logo=cloudsmith&style=for-the-badge)](https://cloudsmith.com)

Package repository hosting is graciously provided by  [Cloudsmith](https://cloudsmith.com).
Cloudsmith is the only fully hosted, cloud-native, universal package management solution, that
enables your organization to create, store and share packages in any format, to any place, with total
confidence.

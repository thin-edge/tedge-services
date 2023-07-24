# tedge-services

WIP: thin-edge.io service file definitions for the following init systems

* openrc
* sysvinit
* s6-overlay

## Pre-requisites

You need to have [nfpm](https://nfpm.goreleaser.com/install/) installed first before running the build tasks.

## Build

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

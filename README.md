# tedge-services

WIP: thin-edge.io service file definitions for the following init systems

* openrc
* sysvinit
* s6-overlay

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

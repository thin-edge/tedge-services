# tedge-services-openrc
WIP: thin-edge.io openrc service files

## Build

1. Update the service files

    ```sh
    just generate
    ```

2. Build the packages

    ```sh
    just build
    ```

3. Start test containers (one per init system)

    ```sh
    just start
    ```

4. Start a console and test the functions

    **Start console inside one of the containers**

    ```sh
    docker compose exec tedge-sysvinit sh
    ```

    **Check service**

    ```sh
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

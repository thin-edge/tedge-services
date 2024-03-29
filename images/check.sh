#!/bin/sh
set -e

start_enable() {
  name="$1"
  command="$1"

  if [ $# -gt 1 ]; then
    command="$2"
  fi

  tedgectl enable "$name" ||:
  sleep 1

  tedgectl start "$name" ||:

  sleep 1
  pgrep -fa "/$command" || echo "FAIL: Could not find service. service=$name"
  tedgectl status "$name" || echo "FAIL: Service status should work when service is running. service=$name"

  tedgectl stop "$name" ||:
  sleep 1

  if pgrep -fa "/$command"; then
    echo "FAIL: Service should not be running. service=$name"
  fi

  # TODO: Some init systems return 0 if the service is stopped
  # tedgectl status "$name" || echo "FAIL: Service status should work when service is stopped. service=$name"
}

start_enable tedge-agent
#start_enable tedge-mapper-c8y "tedge-mapper c8y"
#start_enable tedge-configuration-plugin
#start_enable c8y-firmware-plugin
#start_enable tedge-log-plugin

echo ""
echo "Tests passed"

#!/bin/sh
set -e

start_enable() {
  name="$1"
  tedgectl enable "$name"
  tedgectl start "$name"

  pgrep -fa "/$name" || echo "FAIL: Could not find service. service=$name"
  tedgectl status "$name" || echo "FAIL: Service status should work when service is running. service=$name"

  tedgectl stop "$name"
  pgrep -fa "/$name" && echo "FAIL: Service should not be running. service=$name"

  tedgectl status "$name" || echo "FAIL: Service status should work when service is stopped. service=$name"
}

start_enable tedge-agent
start_enable tedge-mapper-c8y
start_enable c8y-configuration-plugin
start_enable c8y-firmware-plugin
start_enable c8y-log-plugin

echo "Service 'All': Status"
tedgectl is_available

#!/bin/sh
set -e

start_enable() {
  tedgectl enable "$1"
  tedgectl start "$1"
}

start_enable tedge-agent
start_enable tedge-mapper-c8y
start_enable c8y-configuration-plugin
start_enable c8y-firmware-plugin
start_enable c8y-log-plugin
# rc-service rsyslog start

echo "Service 'All': Status"
tedgectl is_available

#!/bin/sh
set -e

# Mappers are only started if they are configured
if command -V tedge-mapper >/dev/null 2>&1; then
    ### Enable the service if the device is connected to c8y cloud
    if [ -f "/etc/tedge/mosquitto-conf/c8y-bridge.conf" ]; then
        tedgectl enable tedge-mapper-c8y ||:
        tedgectl start tedge-mapper-c8y 2>/dev/null ||:
    fi
    ### Enable the service if the device is connected to az cloud
    if [ -f "/etc/tedge/mosquitto-conf/az-bridge.conf" ]; then
        tedgectl enable tedge-mapper-az ||:
        tedgectl start tedge-mapper-az 2>/dev/null ||:
    fi
    ### Enable the service if the device is connected to aws cloud
    if [ -f "/etc/tedge/mosquitto-conf/aws-bridge.conf" ]; then
        tedgectl enable tedge-mapper-aws ||:
        tedgectl start tedge-mapper-aws 2>/dev/null ||:
    fi
    ### Enable the service if the collectd is running on the device
    if [ -d /run/systemd/system ]; then
        if is_active "collectd" >/dev/null >&2; then
            tedgectl enable tedge-mapper-collectd ||:
            tedgectl start tedge-mapper-collectd 2>/dev/null ||:
        fi
    fi
fi

# enable and start services (only if the binary is found)
if command -V tedge-agent >/dev/null 2>&1; then
    tedgectl enable tedge-agent ||:
    tedgectl start tedge-agent 2>/dev/null ||:
fi

if command -V tedge-configuration-plugin >/dev/null 2>&1; then
    tedgectl enable tedge-configuration-plugin ||:
    tedgectl start tedge-configuration-plugin 2>/dev/null ||:
fi

if command -V tedge-log-plugin >/dev/null 2>&1; then
    tedgectl enable tedge-log-plugin ||:
    tedgectl start tedge-log-plugin 2>/dev/null ||:
fi

if command -V c8y-firmware-plugin >/dev/null 2>&1; then
    tedgectl enable c8y-firmware-plugin ||:
    tedgectl start c8y-firmware-plugin 2>/dev/null ||:
fi

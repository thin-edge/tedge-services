#!/bin/sh

# enable and start services (only if the binary is found)
if command -V tedge-agent >/dev/null 2>&1; then
    tedgectl enable tedge-agent
    tedgectl start tedge-agent
fi

if command -V tedge-mapper-c8y >/dev/null 2>&1; then
    tedgectl enable tedge-mapper-c8y
    tedgectl start tedge-mapper-c8y
fi

if command -V c8y-configuration-plugin >/dev/null 2>&1; then
    tedgectl enable c8y-configuration-plugin
    tedgectl start c8y-configuration-plugin
fi

if command -V c8y-log-plugin >/dev/null 2>&1; then
    tedgectl enable c8y-log-plugin
    tedgectl start c8y-log-plugin
fi

if command -V c8y-firmware-plugin >/dev/null 2>&1; then
    tedgectl enable c8y-firmware-plugin
    tedgectl start c8y-firmware-plugin
fi

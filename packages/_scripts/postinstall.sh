#!/bin/sh

# enable services (only if the binary is found)
command -V tedge-agent >/dev/null 2>&1 && tedgectl enable tedge-agent
command -V tedge-mapper-c8y >/dev/null 2>&1 && tedgectl enable tedge-mapper-c8y
command -V c8y-configuration-plugin >/dev/null 2>&1 && tedgectl enable c8y-configuration-plugin
command -V c8y-log-plugin >/dev/null 2>&1 && tedgectl enable c8y-log-plugin
command -V c8y-firmware-plugin >/dev/null 2>&1 && tedgectl enable c8y-firmware-plugin

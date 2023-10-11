#!/bin/sh
set -e

# disable services (ignore if not found)
tedgectl disable tedge-agent 2>/dev/null ||:
tedgectl disable tedge-mapper-c8y 2>/dev/null ||:
tedgectl disable c8y-configuration-plugin 2>/dev/null ||:
tedgectl disable tedge-log-plugin 2>/dev/null ||:
tedgectl disable c8y-firmware-plugin 2>/dev/null ||:

# stop services (ignore if not found)
tedgectl stop tedge-agent 2>/dev/null ||:
tedgectl stop tedge-mapper-c8y 2>/dev/null ||:
tedgectl stop c8y-configuration-plugin 2>/dev/null ||:
tedgectl stop tedge-log-plugin 2>/dev/null ||:
tedgectl stop c8y-firmware-plugin 2>/dev/null ||:

#!/bin/sh

# disable services (ignore if not found)
tedgectl disable tedge-agent 2>/dev/null ||:
tedgectl disable tedge-mapper-c8y 2>/dev/null ||:
tedgectl disable c8y-configuration-plugin 2>/dev/null ||:
tedgectl disable c8y-log-plugin 2>/dev/null ||:
tedgectl disable c8y-firmware-plugin 2>/dev/null ||:

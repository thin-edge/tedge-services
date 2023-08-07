#!/bin/sh

# stop services (ignore if not found)
tedgectl stop tedge-agent 2>/dev/null ||:
tedgectl stop tedge-mapper-c8y 2>/dev/null ||:
tedgectl stop c8y-configuration-plugin 2>/dev/null ||:
tedgectl stop c8y-log-plugin 2>/dev/null ||:
tedgectl stop c8y-firmware-plugin 2>/dev/null ||:

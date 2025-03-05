#!/bin/sh
set -e

# Only add if /etc/sudoers.d exists
if [ -d /etc/sudoers.d ]; then
    echo "Adding tedgectl to /etc/sudoers.d/tedgectl" >&2
    echo "tedge    ALL = (ALL) NOPASSWD: /usr/bin/tedgectl" > /etc/sudoers.d/100-tedge-tedgectl
fi

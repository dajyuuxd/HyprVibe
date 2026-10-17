#!/bin/bash
HOST=$(cat /etc/hostname 2>/dev/null || uname -n)
USER="${USER:-$(id -un)}"
printf "%s@%s\n" "$HOST" "$USER"

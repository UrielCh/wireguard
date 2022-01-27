#!/bin/bash
. .env

for USR in $(grep user: wg${WGID}.conf | cut -d: -f2)
do
echo -n "${USR}, "
done
echo
echo

#!/bin/bash
. .env
. common.sh

for USR in $(grep user: wg${WGID}.conf | cut -d: -f2)
do
echo -n "${USR}, "
done
echo
echo

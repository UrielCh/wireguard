#!/bin/bash
. .env

grep user: wg${WGID}.conf | cut -d: -f2

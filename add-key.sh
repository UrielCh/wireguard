#!/bin/bash
# systemctl restart wg-quick@wg1.service
# ./printKey.sh  david-phone | qrencode -t ansiutf8
. .env

if [ "$#" -ne 2 ]
then
 >&2 echo usage:
 >&2 echo $0 ID[0-250] name  \>\> wg${WGID}.conf
 >&2 echo
 >&2 echo example:
 >&2 echo $0 246 debo \>\> wg${WGID}.conf
 >&2 echo $0 243 david-phone \>\> wg${WGID}.conf
 exit 1
fi
# for X in {3..30}; do ./add-key.sh $X g$X >> wg17.conf; done
#
# if [[ ! $1 =~ '[12]?[0-9]{1,2}' ]]; then first param must be a number

if [[ ! $1 -gt 0 ]]; then echo first param must must be a number 1-253; exit; fi
if [[ ! $1 -lt 254 ]]; then echo first param must must be a number 1-253; exit; fi

C1=$(grep -c 10\\.${IP2}\\.0\\.$1/ wg${WGID}.conf)

if [ $C1 -ne 0 ]
then
  >&2 echo IP $1 already taken
  exit 1
fi

C2="$(grep -c user:$2$ wg${WGID}.conf)"

if [ $C2 -ne 0 ]
then
  >&2 echo user $2 already exists
  exit 1
fi

K=$(grep ^${2}: allKeys.txt | cut -d: -f2)

if [ -z "$K" ]
then
 K=$(wg genkey);
 echo ${2}:$K >> allKeys.txt
fi
P=$(echo $K | wg pubkey)

cat << EOF

[Peer]
# user:$2
#PrivateKey = $K
PublicKey = $P
AllowedIps = ${IP1}.${IP2}.${IP3}.$1/32

EOF

>&2 echo
>&2 echo now restart wireguard service to take effect
# >&2 echo "add this key in wg${WGID}.conf then"
>&2 echo systemctl restart wg-quick@wg${WGID}.service
